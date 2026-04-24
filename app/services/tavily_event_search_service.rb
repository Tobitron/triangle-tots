class TavilyEventSearchService
  include HTTParty

  base_uri "https://api.tavily.com"

  CACHE_KEY      = "tavily_event_search"
  CACHE_DURATION = 6.hours
  POLL_INTERVAL  = 5   # seconds between status checks
  POLL_TIMEOUT   = 180 # seconds before giving up

  def self.fetch_items
    Rails.cache.fetch(CACHE_KEY, expires_in: CACHE_DURATION) do
      research_and_normalize
    end
  rescue => e
    Rails.logger.error("Tavily event search failed: #{e.message}")
    []
  end

  private

  def self.research_and_normalize
    request_id = submit_research
    return [] unless request_id

    result = poll_for_result(request_id)
    return [] unless result

    parse_result(result)
  end

  def self.submit_research
    response = post(
      "/research",
      headers: auth_headers,
      body: {
        input: research_prompt,
        model: "mini"
      }.to_json
    )

    unless response.code == 201 || response.success?
      Rails.logger.error("Tavily research submission failed (#{response.code}): #{response.body}")
      return nil
    end

    request_id = response.parsed_response["request_id"]
    Rails.logger.info("Tavily research submitted, request_id: #{request_id}")
    request_id
  end

  def self.poll_for_result(request_id)
    deadline = Time.current + POLL_TIMEOUT.seconds

    loop do
      response = get("/research/#{request_id}", headers: auth_headers)

      unless response.success?
        Rails.logger.error("Tavily poll failed (#{response.code}): #{response.body}")
        return nil
      end

      data = response.parsed_response
      status = data["status"]

      if status == "completed"
        Rails.logger.info("Tavily research completed in #{data["response_time"]}s")
        return data
      end

      if Time.current > deadline
        Rails.logger.error("Tavily research timed out after #{POLL_TIMEOUT}s")
        return nil
      end

      Rails.logger.debug("Tavily research status: #{status}, waiting...")
      sleep POLL_INTERVAL
    end
  end

  def self.parse_result(result)
    content = result["content"].to_s.strip
    return [] if content.blank?

    # Tavily may return JSON directly (via output_schema) or prose — handle both
    json_text = extract_json(content)

    if json_text
      events = JSON.parse(json_text)
      return events.filter_map { |e| normalize(e) } if events.is_a?(Array)
    end

    # Fall back to Claude Haiku extraction if JSON parsing failed
    Rails.logger.info("Tavily content not structured JSON, falling back to Claude extraction")
    extract_with_claude(content, result["sources"] || [])
  rescue JSON::ParserError
    Rails.logger.info("Tavily JSON parse failed, falling back to Claude extraction")
    extract_with_claude(content, result["sources"] || [])
  end

  def self.extract_json(text)
    text = text.gsub(/\A```(?:json)?\n?/, "").gsub(/\n?```\z/, "").strip
    match = text.match(/\[.*\]/m)
    match ? match[0] : (text.start_with?("[") ? text : nil)
  end

  def self.extract_with_claude(content, sources)
    sources_text = sources.map { |s| "#{s["title"]}: #{s["url"]}" }.join("\n")

    client = Anthropic::Client.new(api_key: ENV.fetch("ANTHROPIC_API_KEY"))
    response = client.messages.create(
      model:      "claude-haiku-4-5-20251001",
      max_tokens: 4096,
      messages:   [ { role: "user", content: claude_extraction_prompt(content, sources_text) } ]
    )

    text = response.content.find { |b| b.type == :text }&.text.to_s.strip
    json_text = extract_json(text)
    return [] unless json_text

    events = JSON.parse(json_text)
    return [] unless events.is_a?(Array)
    events.filter_map { |e| normalize(e) }
  rescue => e
    Rails.logger.error("Claude extraction fallback failed: #{e.message}")
    []
  end

  def self.research_prompt
    weekend = upcoming_weekend_dates
    <<~PROMPT
      Give me a list of one-time or special events happening this upcoming weekend (#{weekend}) in the Chapel Hill and Durham area that are appropriate for a 2–4 year old.

      Requirements:
      - Must be one-time, limited-run, or seasonal events (not recurring weekly programming)
      - A 2-year-old must be able to actively participate without adult assistance — not just observe
      - The event must be primarily designed for families or children — not an adult or pet event that a child could theoretically attend
      - Passive events (performances, festivals with no kid activities) should be excluded
      - Include outdoor events, festivals, community events, farm events, vehicle events, and similar
      - Prioritize events where a 2–4 year old can actively participate
      - Maximum cost $15 per person — exclude anything more expensive

      Exclude:
      - Farmers markets
      - Museums unless it's a special one-time event
      - Recurring storytimes, classes, or weekly programming
      - Garden tours, nature walks, or any event where children observe rather than do

      For each event found, provide:
      - Event name
      - Description of what a toddler can specifically do there (1-3 sentences)
      - Date and time
      - Location/address
      - Cost (free, or approximate price)
      - Website or event URL
    PROMPT
  end

  def self.claude_extraction_prompt(content, sources_text)
    <<~PROMPT
      Extract structured event data from the research report below. Return ONLY a JSON array — no prose, no markdown fences.

      Exclude any event where: cost exceeds $15 per person (cost_level 3), children observe rather than actively participate, it is a garden tour, nature walk, or passive experience, or it is primarily an adult or pet event that children could merely attend.

      Each element must have:
      - "name": string
      - "description": string (1-3 sentences on what a toddler can specifically do)
      - "start_date": ISO 8601 with Eastern offset e.g. "#{Date.current.year}-04-26T10:00:00-04:00" (use noon if time unknown)
      - "end_date": ISO 8601 or null
      - "address": city and state or full address, or null
      - "cost_level": 0=free 1=$1-5 2=$6-15 3=$16+
      - "activity_type": one of: playground library museum park splash_pad indoor_play farm nature_trail class_activity event restaurant
      - "source_url": URL from sources below (required — omit events without a URL)
      - "registration_url": null

      Sources:
      #{sources_text}

      Research report:
      #{content}
    PROMPT
  end

  def self.normalize(event)
    start_dt = parse_datetime(event["start_date"])
    return nil unless start_dt
    return nil if event["name"].blank? || event["source_url"].blank?

    {
      name:             event["name"].strip,
      description:      event["description"]&.strip,
      start_date:       start_dt,
      end_date:         parse_datetime(event["end_date"]) || start_dt + 2.hours,
      address:          event["address"]&.strip,
      latitude:         nil,
      longitude:        nil,
      cost_level:       event["cost_level"].to_i.clamp(0, 3),
      categories:       [ event["activity_type"] ].compact,
      source_url:       event["source_url"].strip,
      registration_url: event["registration_url"]&.strip
    }
  rescue => e
    Rails.logger.error("Tavily normalize error: #{e.message}")
    nil
  end

  def self.parse_datetime(str)
    return nil if str.blank?
    Time.iso8601(str).in_time_zone("Eastern Time (US & Canada)")
  rescue ArgumentError, TypeError
    nil
  end

  def self.auth_headers
    {
      "Authorization" => "Bearer #{ENV.fetch("TAVILY_API_KEY")}",
      "Content-Type"  => "application/json"
    }
  end

  def self.upcoming_weekend_dates
    today = Date.current
    days_until_saturday = (6 - today.wday) % 7
    days_until_saturday = 7 if days_until_saturday.zero?
    saturday = today + days_until_saturday
    "#{saturday.strftime('%A %B %-d')} and #{(saturday + 1).strftime('%A %B %-d, %Y')}"
  end
end
