class SyncEventsJob < ApplicationJob
  queue_as :default

  # Retry on network errors, not on parsing errors
  retry_on Net::ReadTimeout, Net::OpenTimeout, wait: 5.minutes, attempts: 3
  retry_on Anthropic::Errors::APIConnectionError, Anthropic::Errors::APITimeoutError, wait: 2.minutes, attempts: 3

  def perform
    Rails.logger.info("Starting event sync")

    sync_start = Time.current
    results = { fetched: 0, created: 0, updated: 0, skipped: 0, failed: 0, errors: [] }

    sync_rss(results)
    sync_triangle_mom(results)
    sync_tavily(results)

    Rails.logger.info("Event sync complete: #{results.slice(:fetched, :created, :updated, :skipped, :failed).inspect}")

    quality_filter_synced_events(sync_start)

    results
  rescue => e
    Rails.logger.error("Event sync failed: #{e.message}")
    Rails.logger.error(e.backtrace.first(5).join("\n"))
    raise
  end

  private

  def quality_filter_synced_events(since)
    activities = Activity.where(is_event: true, last_synced_at: since..)
                         .where("start_date > ?", 1.day.ago)
    return if activities.empty?

    Rails.logger.info("EventQualityFilter: checking #{activities.count} synced events")
    EventQualityFilter.filter(activities)
  end

  def sync_rss(results)
    items = RssFeedService.fetch_items
    Rails.logger.warn("No items fetched from RSS feed") and return if items.empty?

    suitable = RssAgeFilter.filter(items)
    Rails.logger.info("RSS: #{suitable.count}/#{items.count} events suitable for toddlers")

    results[:fetched] += suitable.count
    suitable.each { |item| process_item(item, results) }
  end

  def sync_tavily(results)
    items = TavilyEventSearchService.fetch_items
    Rails.logger.warn("No items fetched from Tavily") and return if items.empty?

    Rails.logger.info("Tavily: #{items.count} events found")
    results[:fetched] += items.count
    items.each { |item| process_tavily_item(item, results) }
  end

  def process_tavily_item(item, results)
    if item[:start_date] < 1.day.ago
      results[:skipped] += 1
      return
    end

    result = EventImporter.import(item, item[:source_url])

    if result[:success]
      if result[:created]
        results[:created] += 1
        Rails.logger.info("Created Tavily event: #{item[:name]}")
      else
        results[:updated] += 1
        Rails.logger.info("Updated Tavily event: #{item[:name]}")
      end
    else
      results[:failed] += 1
      error_msg = "#{item[:source_url]}: #{result[:errors].join(", ")}"
      results[:errors] << error_msg
      Rails.logger.warn("Failed to import Tavily event: #{error_msg}")
    end
  rescue => e
    results[:failed] += 1
    results[:errors] << "#{item[:source_url]}: #{e.message}"
    Rails.logger.error("Error processing Tavily event: #{e.message}")
  end

  def sync_triangle_mom(results)
    items = TriangleMomService.fetch_items
    Rails.logger.warn("No items fetched from Triangle Mom") and return if items.empty?

    suitable = TriangleMomAgeFilter.filter(items)
    Rails.logger.info("Triangle Mom: #{suitable.count}/#{items.count} events selected")

    results[:fetched] += suitable.count
    suitable.each { |item| process_triangle_mom_item(item, results) }
  end

  def process_triangle_mom_item(item, results)
    # Skip past events
    if item[:start_date] < 1.day.ago
      results[:skipped] += 1
      return
    end

    result = EventImporter.import(item, item[:source_url])

    if result[:success]
      if result[:created]
        results[:created] += 1
        Rails.logger.info("Created Triangle Mom event: #{item[:name]}")
      else
        results[:updated] += 1
        Rails.logger.info("Updated Triangle Mom event: #{item[:name]}")
      end
    else
      results[:failed] += 1
      error_msg = "#{item[:source_url]}: #{result[:errors].join(", ")}"
      results[:errors] << error_msg
      Rails.logger.warn("Failed to import Triangle Mom event: #{error_msg}")
    end
  rescue => e
    results[:failed] += 1
    results[:errors] << "#{item[:source_url]}: #{e.message}"
    Rails.logger.error("Error processing Triangle Mom event: #{e.message}")
  end

  def process_item(item, results)
    # Parse content
    parsed = EventContentParser.parse(item[:content], {
      title: item[:title],
      categories: item[:categories],
      pub_date: item[:pub_date]
    })

    # Skip if parsing failed
    unless parsed
      results[:failed] += 1
      results[:errors] << "#{item[:link]}: Parsing failed"
      return
    end

    # Skip if missing critical fields
    unless parsed[:name].present? && parsed[:start_date].present?
      results[:skipped] += 1
      results[:errors] << "#{item[:link]}: Missing name or start_date"
      return
    end

    # Skip past events (older than yesterday)
    if parsed[:start_date] < 1.day.ago
      results[:skipped] += 1
      return # Silently skip old events
    end

    # Import to database
    result = EventImporter.import(parsed, item[:link])

    if result[:success]
      if result[:created]
        results[:created] += 1
        Rails.logger.info("Created event: #{parsed[:name]}")
      else
        results[:updated] += 1
        Rails.logger.info("Updated event: #{parsed[:name]}")
      end
    else
      results[:failed] += 1
      error_msg = "#{item[:link]}: #{result[:errors].join(', ')}"
      results[:errors] << error_msg
      Rails.logger.warn("Failed to import: #{error_msg}")
    end

  rescue => e
    results[:failed] += 1
    error_msg = "#{item[:link]}: #{e.message}"
    results[:errors] << error_msg
    Rails.logger.error("Error processing item: #{error_msg}")
    Rails.logger.error(e.backtrace.first(3).join("\n"))
  end
end
