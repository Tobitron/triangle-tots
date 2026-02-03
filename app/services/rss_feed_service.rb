require 'rss'
require 'open-uri'

class RssFeedService
  FEED_URL = "https://triangleonthecheap.com/category/kids/feed/"
  CACHE_KEY = "triangle_rss_feed"
  CACHE_DURATION = 1.hour
  REQUEST_TIMEOUT = 30

  # Fetch RSS items from the feed
  # Returns array of RSS items or empty array on error
  def self.fetch_items
    Rails.cache.fetch(CACHE_KEY, expires_in: CACHE_DURATION) do
      fetch_and_parse_feed
    end
  rescue => e
    Rails.logger.error("RSS feed fetch failed: #{e.message}")
    []
  end

  # Check if RSS item has been updated since activity's last sync
  def self.item_updated?(item, activity)
    return true if activity.last_synced_at.nil?
    item.pubDate.to_time > activity.last_synced_at
  end

  private

  def self.fetch_and_parse_feed
    Rails.logger.info("Fetching RSS feed from #{FEED_URL}")

    URI.open(FEED_URL, read_timeout: REQUEST_TIMEOUT) do |rss|
      feed = RSS::Parser.parse(rss)
      items = feed.items.map do |item|
        {
          title: item.title,
          link: item.link,
          pub_date: item.pubDate,
          content: item.content_encoded || item.description,
          categories: extract_categories(item)
        }
      end

      Rails.logger.info("Fetched #{items.count} items from RSS feed")
      items
    end
  rescue Net::ReadTimeout, Net::OpenTimeout => e
    Rails.logger.error("Network timeout fetching RSS: #{e.message}")
    []
  rescue RSS::Error => e
    Rails.logger.error("RSS parsing error: #{e.message}")
    []
  end

  def self.extract_categories(item)
    return [] unless item.respond_to?(:categories)

    item.categories.map do |cat|
      cat.respond_to?(:content) ? cat.content : cat.to_s
    end.compact
  end
end
