class LlmTopPicker
  def self.pick(items, count: 5, url_key: :source_url, &label_builder)
    return [] if items.empty?

    client = Anthropic::Client.new(api_key: ENV.fetch("ANTHROPIC_API_KEY"))
    response = client.messages.create(
      model:      "claude-haiku-4-5-20251001",
      max_tokens: 512,
      messages:   [ { role: "user", content: build_prompt(items, count, url_key, label_builder) } ]
    )

    text = response.content.find { |b| b.type == :text }&.text.to_s
    urls = parse_urls(text)
    items.select { |item| urls.include?(item[url_key].to_s) }
  rescue => e
    Rails.logger.error("LlmTopPicker error: #{e.message}")
    []
  end

  private

  def self.build_prompt(items, count, url_key, label_builder)
    event_list = items.map.with_index(1) do |item, i|
      label = label_builder ? label_builder.call(item) : default_label(item)
      "#{i}. URL: #{item[url_key]}\n   #{label}\n"
    end.join("\n")

    <<~PROMPT
      You are selecting the #{count} best weekend activities for a parent with a 2-4 year old toddler in the Chapel Hill / Durham / Carrboro / Cary / Hillsborough area of North Carolina.

      Pick the #{count} best options from the list below. Prioritize in this order:
      1. Events specifically designed for toddlers or ages 2-4 — story times, sensory play, animal interactions, toddler crafts
      2. Special or infrequent events — one-time or seasonal happenings over recurring weekly activities
      3. Hands-on participation — the child is actively doing something, not watching adults perform
      4. Morning timing — events starting before noon are preferred
      5. Small, intimate scale — a library story time beats a large outdoor gathering
      6. Free or low cost (under $10)
      7. Located in Chapel Hill, Durham, Carrboro, Cary, or Hillsborough only
      8. No festivals, fairs, or large multi-vendor outdoor gatherings

      #{event_list}
      Respond ONLY with a JSON array of the #{count} best URLs, best first:
      ["https://...", "https://...", ...]
    PROMPT
  end

  def self.default_label(item)
    name = item[:name] || item[:title]
    desc = item[:description].to_s.truncate(300)
    "Title: #{name}\n   Description: #{desc}"
  end

  def self.parse_urls(text)
    json = text[/\[.*\]/m]
    return Set.new unless json
    urls = JSON.parse(json)
    urls.is_a?(Array) ? urls.map(&:strip).to_set : Set.new
  rescue JSON::ParserError => e
    Rails.logger.error("LlmTopPicker could not parse response: #{e.message}")
    Set.new
  end
end
