class RssAgeFilter
  CACHE_KEY      = "rss_age_filter_top5"
  CACHE_DURATION = 1.hour

  EXCLUDED_CITIES = %w[
    Raleigh Apex Morrisville Wendell Mebane Pittsboro Saxapahaw Garner Clayton
    Fuquay-Varina Knightdale Zebulon Smithfield
  ].freeze

  EXCLUDED_CITIES_MULTI_WORD = [ "Wake Forest", "Mount Olive", "New Hill", "Holly Springs" ].freeze

  FESTIVAL_PATTERN = /\b(fest(ival)?|fair|carnival|expo|jubilee)\b/i

  def self.filter(items)
    return [] if items.empty?

    cached = Rails.cache.read(CACHE_KEY)
    return cached if cached

    candidates = pre_filter(items)
    Rails.logger.info("RssAgeFilter: #{candidates.count}/#{items.count} candidates after pre-filter")

    result = LlmTopPicker.pick(candidates, url_key: :link) do |item|
      content = ActionView::Base.full_sanitizer.sanitize(item[:content].to_s).squish.truncate(500)
      "Title: #{item[:title]}\n   Description: #{content}"
    end

    Rails.cache.write(CACHE_KEY, result, expires_in: CACHE_DURATION)
    result
  rescue => e
    Rails.logger.error("RssAgeFilter failed: #{e.message}")
    []
  end

  private

  def self.pre_filter(items)
    items.reject do |item|
      title   = item[:title].to_s
      content = ActionView::Base.full_sanitizer.sanitize(item[:content].to_s).squish
      context = "#{title} #{content}"

      next true if title.match?(FESTIVAL_PATTERN)
      next true if EXCLUDED_CITIES.any? { |c| context.match?(/\b#{Regexp.escape(c)}\b/i) && context.match?(/\b(NC|North Carolina)\b/i) }
      next true if EXCLUDED_CITIES_MULTI_WORD.any? { |c| context.include?(c) }

      false
    end
  end
end
