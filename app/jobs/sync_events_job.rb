class SyncEventsJob < ApplicationJob
  queue_as :default

  # Retry on network errors, not on parsing errors
  retry_on Net::ReadTimeout, Net::OpenTimeout, wait: 5.minutes, attempts: 3

  def perform
    Rails.logger.info("Starting event sync from Triangle on the Cheap")

    results = {
      fetched: 0,
      created: 0,
      updated: 0,
      skipped: 0,
      failed: 0,
      errors: []
    }

    begin
      # Fetch RSS items
      items = RssFeedService.fetch_items
      results[:fetched] = items.count

      if items.empty?
        Rails.logger.warn("No items fetched from RSS feed")
        return results
      end

      # Process each item
      items.each do |item|
        process_item(item, results)
      end

      Rails.logger.info("Event sync complete: #{results.slice(:fetched, :created, :updated, :skipped, :failed).inspect}")
      results

    rescue => e
      Rails.logger.error("Event sync failed: #{e.message}")
      Rails.logger.error(e.backtrace.first(5).join("\n"))
      raise # Re-raise to trigger retry
    end
  end

  private

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
