class TriangleMomAgeFilter
  CACHE_KEY      = "triangle_mom_top5"
  CACHE_DURATION = 1.hour

  ALLOWED_CITIES = [ "Chapel Hill", "Durham", "Carrboro", "Cary", "Hillsborough" ].freeze

  ADULT_VENUE    = /brew(ery|ing)\b|winer(y|ies)\b|distiller(y|ies)\b|\btavern\b|cannabis\b/i
  OLDER_CONTENT  = /\bteen(s|ager)?\b|\btween\b|middle school|high school|\badult\b|networking\b/i
  AGE_TOO_OLD    = /\bages?\s*(5|6|7|8|9|10|11|12|\d{2})\s*(\+|and up|& ?up)|\b(5|6|7|8|9|10|11|12)\+\s*(year|yr)s?\s*old/i
  FESTIVAL_PATTERN = /\b(fest(ival)?|fair|carnival|expo|jubilee)\b/i

  def self.filter(items)
    return [] if items.empty?

    cached = Rails.cache.read(CACHE_KEY)
    return cached if cached

    candidates = pre_filter(items)
    Rails.logger.info("TriangleMomAgeFilter: #{candidates.count}/#{items.count} candidates after pre-filter")

    result = LlmTopPicker.pick(candidates, url_key: :source_url) do |item|
      address = item[:address].presence || "address unknown"
      date    = item[:start_date]&.strftime("%-m/%-d at %-I:%M%p") || "date unknown"
      cost    = [ "free", "$1-5", "$6-15", "$16+" ][item[:cost_level].to_i] || "unknown cost"
      "Title: #{item[:name]}\n   Date: #{date} | #{address} | #{cost}\n   Description: #{item[:description].to_s.truncate(300)}"
    end

    Rails.cache.write(CACHE_KEY, result, expires_in: CACHE_DURATION)
    result
  rescue => e
    Rails.logger.error("TriangleMomAgeFilter failed: #{e.message}")
    []
  end

  private

  def self.pre_filter(items)
    items.reject do |item|
      text    = [ item[:name], item[:description], item[:categories]&.join(" "), item[:age_groups]&.join(" ") ].compact.join(" ")
      address = item[:address].to_s

      next true if text.match?(ADULT_VENUE)
      next true if text.match?(OLDER_CONTENT)
      next true if text.match?(AGE_TOO_OLD)
      next true if item[:name].to_s.match?(FESTIVAL_PATTERN)
      next true if address.present? && ALLOWED_CITIES.none? { |c| address.include?(c) }

      false
    end
  end
end
