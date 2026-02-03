require 'nokogiri'

class EventContentParser
  # Parse HTML content and metadata into structured event data
  # Returns hash with event fields or nil if parsing fails
  def self.parse(html_content, metadata)
    return nil if html_content.blank?

    doc = Nokogiri::HTML(html_content)

    {
      name: extract_name(metadata[:title]),
      description: extract_description(doc),
      start_date: extract_start_date(doc, metadata),
      end_date: extract_end_date(doc, metadata),
      address: extract_address(doc),
      cost_level: extract_cost_level(doc),
      registration_url: extract_registration_url(doc),
      categories: metadata[:categories] || []
    }
  rescue => e
    Rails.logger.error("Event parsing error: #{e.message}")
    nil
  end

  private

  # Extract event name from RSS title
  # Clean up: remove date suffixes, ellipsis, etc.
  def self.extract_name(title)
    return nil if title.blank?

    # Remove common suffixes like "on March 22" or "..."
    cleaned = title.gsub(/ on \w+ \d+.*$/, '')
                   .gsub(/\.\.\..*$/, '')
                   .strip

    cleaned.presence || title
  end

  # Extract dates from content using pattern matching
  def self.extract_start_date(doc, metadata)
    text = doc.text

    # Try multiple date patterns
    date_patterns = [
      # "Sunday, March 22, 2026, from 12 to 5 p.m."
      /(\w+,?\s+\w+\s+\d{1,2},?\s+\d{4})/,
      # "March 22, 2026"
      /(\w+\s+\d{1,2},?\s+\d{4})/,
      # "3/22/2026"
      /(\d{1,2}\/\d{1,2}\/\d{4})/
    ]

    date_patterns.each do |pattern|
      match = text.match(pattern)
      next unless match

      begin
        # Use Chronic for natural language parsing if available
        parsed = if defined?(Chronic)
          Chronic.parse(match[1], context: :future)
        else
          Date.parse(match[1])
        end

        # Extract time if present
        time_match = text.match(/from\s+(\d{1,2}):?(\d{2})?\s*(a\.m\.|p\.m\.|am|pm)/i)
        if time_match && parsed
          hour = time_match[1].to_i
          minute = time_match[2]&.to_i || 0
          is_pm = time_match[3].downcase.include?('p')

          # Convert to 24-hour format
          hour = 12 if hour == 12 && !is_pm
          hour += 12 if is_pm && hour != 12

          return parsed.change(hour: hour, min: minute)
        end

        return parsed
      rescue ArgumentError, TypeError
        next
      end
    end

    nil
  end

  # Extract end time from content
  def self.extract_end_date(doc, metadata)
    text = doc.text
    start_date = extract_start_date(doc, metadata)
    return nil unless start_date

    # Look for "from X to Y p.m." pattern
    time_match = text.match(/from\s+\d{1,2}:?(\d{2})?\s*(?:a\.m\.|p\.m\.|am|pm)\s+to\s+(\d{1,2}):?(\d{2})?\s*(a\.m\.|p\.m\.|am|pm)/i)

    if time_match
      hour = time_match[2].to_i
      minute = time_match[3]&.to_i || 0
      is_pm = time_match[4].downcase.include?('p')

      # Convert to 24-hour format
      hour = 12 if hour == 12 && !is_pm
      hour += 12 if is_pm && hour != 12

      return start_date.change(hour: hour, min: minute)
    end

    # Default: end time is 2 hours after start
    start_date + 2.hours
  end

  # Extract physical address from content
  def self.extract_address(doc)
    text = doc.text

    # Pattern: street number + street name + city + state
    address_patterns = [
      # "1006 Southwest Maynard Road, Cary, North Carolina"
      /(\d+ [^,]+(?:Road|Street|Avenue|Drive|Blvd|Lane|Court|Way|Circle|Place)(?:[^,]+)?),\s*([A-Z][a-z]+(?: [A-Z][a-z]+)?),\s*(?:North Carolina|NC)/i,
      # Simpler: "123 Main St, Durham, NC"
      /(\d+ [^,]+),\s*([A-Z][a-z]+),\s*(?:NC|North Carolina)/i
    ]

    address_patterns.each do |pattern|
      match = text.match(pattern)
      if match
        street = match[1].strip
        city = match[2].strip
        return "#{street}, #{city}, NC"
      end
    end

    nil
  end

  # Extract and map cost information to cost_level (0-3)
  def self.extract_cost_level(doc)
    text = doc.text.downcase

    # Check for free first
    return 0 if text.match?(/\bfree\b/)

    # Extract dollar amounts
    amounts = text.scan(/\$(\d+)/).flatten.map(&:to_i)
    return 0 if amounts.empty?

    max_amount = amounts.max
    case max_amount
    when 0..5 then 1      # Cheap: $1-$5
    when 6..15 then 2     # Moderate: $6-$15
    else 3                # Expensive: $16+
    end
  end

  # Find registration/ticket URLs
  def self.extract_registration_url(doc)
    # Look for links containing registration-related keywords
    doc.css('a').each do |link|
      href = link['href']
      text = link.text.downcase

      next unless href.present?

      # Check for registration keywords
      if text.match?(/register|registration|tickets?|rsvp|sign up/i) ||
         href.match?(/eventbrite|facebook\.com\/events|meetup\.com|register|tickets/i)
        return href
      end
    end

    nil
  end

  # Extract description by combining paragraphs
  def self.extract_description(doc)
    # Get all paragraph text, clean up
    paragraphs = doc.css('p').map { |p| p.text.strip }.reject(&:blank?)

    # Skip common footer/sharing content
    paragraphs.reject! do |p|
      p.match?(/share this|follow us|subscribe|email|facebook|twitter/i)
    end

    # Join first 3-4 paragraphs, limit to 500 words
    description = paragraphs.first(4).join("\n\n")
    words = description.split
    words.first(500).join(' ')
  end
end
