class HoursParser
  # Dawn/dusk times for MVP (fixed)
  DAWN_TIME = "7:00 AM"
  DUSK_TIME = "7:00 PM"

  # Parse hours string for a day and check if open at a given time
  # Returns: true if open, false if closed
  def self.open_at?(hours_string, time)
    return false if hours_string.blank? || hours_string.downcase == "closed"

    # Handle "dawn - dusk" special case
    if hours_string.downcase.include?("dawn") && hours_string.downcase.include?("dusk")
      return time_between?(time, DAWN_TIME, DUSK_TIME)
    end

    # Parse regular hours: "10:00 AM - 6:00 PM"
    parse_hours_range(hours_string, time)
  end

  # Get opening time if activity opens within the next N hours
  # Returns: opening time string (e.g., "2:00 PM") or nil
  def self.opens_within?(hours_string, current_time, within_hours)
    return nil if hours_string.blank? || hours_string.downcase == "closed"

    opening_time = get_opening_time(hours_string)
    return nil if opening_time.nil?

    # Check if opening time is within the specified window
    if opening_time > current_time && opening_time <= current_time + within_hours.hours
      format_time_12hr(opening_time)
    end
  end

  # Get closing time if activity closes within the next N hours
  # Returns: closing time string (e.g., "6:00 PM") or nil
  def self.closes_within?(hours_string, current_time, within_hours)
    return nil if hours_string.blank? || hours_string.downcase == "closed"

    closing_time = get_closing_time(hours_string)
    return nil if closing_time.nil?

    # Check if closing time is within the specified window
    if closing_time > current_time && closing_time <= current_time + within_hours.hours
      format_time_12hr(closing_time)
    end
  end

  # Get the opening time for today
  # Returns: Time object or nil
  def self.get_opening_time(hours_string)
    return nil if hours_string.blank? || hours_string.downcase == "closed"

    if hours_string.downcase.include?("dawn")
      parse_time_to_today(DAWN_TIME)
    else
      # Extract opening time from "10:00 AM - 6:00 PM"
      match = hours_string.match(/^(\d{1,2}:\d{2}\s*(?:AM|PM|am|pm))/i)
      match ? parse_time_to_today(match[1]) : nil
    end
  end

  # Get the closing time for today
  # Returns: Time object or nil
  def self.get_closing_time(hours_string)
    return nil if hours_string.blank? || hours_string.downcase == "closed"

    if hours_string.downcase.include?("dusk")
      parse_time_to_today(DUSK_TIME)
    else
      # Extract closing time from "10:00 AM - 6:00 PM"
      match = hours_string.match(/-\s*(\d{1,2}:\d{2}\s*(?:AM|PM|am|pm))/i)
      match ? parse_time_to_today(match[1]) : nil
    end
  end

  private

  def self.parse_hours_range(hours_string, time)
    opening_time = get_opening_time(hours_string)
    closing_time = get_closing_time(hours_string)

    return false if opening_time.nil? || closing_time.nil?

    time >= opening_time && time < closing_time
  end

  def self.time_between?(time, start_str, end_str)
    start_time = parse_time_to_today(start_str)
    end_time = parse_time_to_today(end_str)

    return false if start_time.nil? || end_time.nil?

    time >= start_time && time < end_time
  end

  # Parse a time string like "10:00 AM" or "2:30 PM" to today's date at that time
  def self.parse_time_to_today(time_str)
    return nil if time_str.blank?

    # Clean up the string (remove extra spaces)
    time_str = time_str.strip

    # Parse the time and set it to today
    begin
      Time.zone.parse("#{Time.current.to_date} #{time_str}")
    rescue ArgumentError
      nil
    end
  end

  # Format a Time object as 12-hour time string (e.g., "2:00 PM")
  def self.format_time_12hr(time)
    time.strftime("%-I:%M %p")
  end
end
