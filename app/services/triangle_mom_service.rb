require "httparty"

class TriangleMomService
  BASE_URL = "https://thetrianglemom.com/api/events"
  CACHE_KEY = "triangle_mom_events"
  CACHE_DURATION = 1.hour

  def self.fetch_items
    Rails.cache.fetch(CACHE_KEY, expires_in: CACHE_DURATION) do
      fetch_and_parse
    end
  rescue => e
    Rails.logger.error("Triangle Mom fetch failed: #{e.message}")
    []
  end

  private

  def self.fetch_and_parse
    response = HTTParty.get(BASE_URL, {
      query: { category: "family", when: "this-weekend" },
      timeout: 30,
      headers: { "Accept" => "application/json" }
    })

    unless response.success?
      Rails.logger.error("Triangle Mom API returned #{response.code}")
      return []
    end

    events = response.parsed_response
    return [] unless events.is_a?(Array)

    Rails.logger.info("Triangle Mom: fetched #{events.count} raw events")
    events.filter_map { |e| normalize(e) }
  rescue => e
    Rails.logger.error("Triangle Mom parse error: #{e.message}")
    []
  end

  def self.normalize(event)
    start_dt = parse_datetime(event["startDate"], event["time"], :start)
    return nil unless start_dt

    {
      name:             event["title"]&.strip,
      description:      event["description"]&.strip,
      start_date:       start_dt,
      end_date:         parse_datetime(event["startDate"], event["time"], :end) || start_dt + 2.hours,
      address:          build_address(event),
      latitude:         event["latitude"]&.to_f.presence,
      longitude:        event["longitude"]&.to_f.presence,
      cost_level:       parse_cost(event["price"]),
      categories:       event["categories"] || [],
      age_groups:       event["ageGroup"] || [],
      source_url:       "https://thetrianglemom.com/events/#{event["slug"]}",
      registration_url: nil
    }
  rescue => e
    Rails.logger.error("Triangle Mom normalize error (#{event["title"]}): #{e.message}")
    nil
  end

  def self.parse_datetime(iso_date, time_str, part)
    return nil if iso_date.blank?

    base = Time.parse(iso_date).in_time_zone("Eastern Time (US & Canada)").to_date

    if time_str.present?
      pattern = part == :start \
        ? /^(\d{1,2}):?(\d{2})?\s*(am|pm)/i \
        : /-\s*(\d{1,2}):?(\d{2})?\s*(am|pm)/i

      if (m = time_str.match(pattern))
        hour = m[1].to_i
        min  = m[2]&.to_i || 0
        pm   = m[3].downcase == "pm"
        hour = 12 if hour == 12 && !pm
        hour += 12 if pm && hour != 12
        return base.in_time_zone("Eastern Time (US & Canada)").change(hour: hour, min: min)
      end
    end

    part == :start ? base.in_time_zone("Eastern Time (US & Canada)").beginning_of_day : nil
  end

  def self.build_address(event)
    parts = [ event["venueAddress"].presence, event["location"].presence ].compact
    parts.empty? ? nil : parts.join(", ")
  end

  def self.parse_cost(price)
    return 0 if price.blank?
    return 0 if price.to_s.downcase.include?("free")

    amounts = price.to_s.scan(/\d+/).map(&:to_i)
    return 0 if amounts.empty?

    case amounts.max
    when 0..5  then 1
    when 6..15 then 2
    else            3
    end
  end
end
