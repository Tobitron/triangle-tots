class Activity < ApplicationRecord
  # Virtual attributes
  attr_accessor :distance      # Calculated distance from home (Milestone 2)
  attr_accessor :status        # Current status (:open, :closing_soon, :opens_soon)
  attr_accessor :status_time   # Time string for status display (e.g., "6:00 PM")

  # Enum for activity types
  enum :activity_type, {
    playground: 'playground',
    library: 'library',
    museum: 'museum',
    park: 'park',
    splash_pad: 'splash_pad',
    indoor_play: 'indoor_play',
    farm: 'farm',
    nature_trail: 'nature_trail',
    class_activity: 'class',
    event: 'event',
    restaurant: 'restaurant'
  }, prefix: true

  # Validations
  validates :name, presence: true
  validates :activity_type, presence: true
  validates :cost_level, inclusion: { in: 0..3 }

  # Event-specific validations
  validates :start_date, :end_date, presence: true, if: :is_event?
  validate :end_date_after_start_date, if: :is_event?

  # Evergreen-specific validations
  validates :hours, presence: true, unless: :is_event?

  # Calculate distance from a given home location
  # Returns distance in miles, or nil if activity has no coordinates
  def distance_from(home_lat, home_lng)
    return nil if latitude.blank? || longitude.blank?
    return nil if home_lat.blank? || home_lng.blank?

    ::Geocoder::Calculations.distance_between(
      [home_lat, home_lng],
      [latitude, longitude],
      units: :mi
    )
  end

  # Get current day's hours string
  def hours_today
    return nil if hours.nil?
    day_name = Time.current.strftime("%A").downcase
    hours[day_name]
  end

  # Is activity open at a given time?
  def open_at?(time = Time.current)
    if is_event?
      # For events, check if time is between start_date and end_date
      return false if start_date.blank? || end_date.blank?
      time >= start_date && time <= end_date
    else
      # For evergreen activities, check hours
      HoursParser.open_at?(hours_today, time)
    end
  end

  # Does activity open within N hours from now?
  # Returns: opening time string or nil
  def opens_within?(within_hours)
    if is_event?
      # For events, check if start_date is within N hours
      return nil if start_date.blank?
      current_time = Time.current
      time_until_start = ((start_date - current_time) / 3600).round # hours

      if time_until_start > 0 && time_until_start <= within_hours
        start_date.strftime("%I:%M %p")
      else
        nil
      end
    else
      # For evergreen activities, check hours
      HoursParser.opens_within?(hours_today, Time.current, within_hours)
    end
  end

  # Does activity close within N hours from now?
  # Returns: closing time string or nil
  def closes_within?(within_hours)
    if is_event?
      # For events, check if end_date is within N hours
      return nil if end_date.blank?
      current_time = Time.current
      time_until_end = ((end_date - current_time) / 3600).round # hours

      if time_until_end > 0 && time_until_end <= within_hours
        end_date.strftime("%I:%M %p")
      else
        nil
      end
    else
      # For evergreen activities, check hours
      HoursParser.closes_within?(hours_today, Time.current, within_hours)
    end
  end

  # Calculate current status for display
  # Returns: [status_symbol, time_string]
  # Status can be: :open, :closing_soon, :opens_soon, or nil
  def calculate_status
    current_time = Time.current

    if is_event?
      # For events, show status based on start/end dates
      if open_at?(current_time)
        # Event is currently happening
        closing_time = closes_within?(1)
        if closing_time
          return [:closing_soon, closing_time]
        else
          # Show end time
          return [:open, end_date.strftime("%I:%M %p")]
        end
      else
        # Event hasn't started yet - check if it starts soon
        opening_time = opens_within?(2)
        if opening_time
          return [:opens_soon, opening_time]
        end
      end
    else
      # For evergreen activities, use hours-based logic
      # Check if currently open
      if open_at?(current_time)
        # Check if closing soon (within 1 hour)
        closing_time = closes_within?(1)
        if closing_time
          # For dawn-dusk, show "dusk" instead of time
          if hours_today&.downcase&.include?("dusk")
            return [:closing_soon, "dusk"]
          else
            return [:closing_soon, closing_time]
          end
        else
          # Show regular closing time
          # For dawn-dusk hours, show "dusk" instead of specific time
          if hours_today&.downcase&.include?("dawn") && hours_today&.downcase&.include?("dusk")
            return [:open, "dusk"]
          else
            closing_time = HoursParser.get_closing_time(hours_today)
            time_str = closing_time ? HoursParser.send(:format_time_12hr, closing_time) : nil
            return [:open, time_str]
          end
        end
      else
        # Check if opens soon (within 2 hours)
        opening_time = opens_within?(2)
        if opening_time
          # For dawn-dusk, show "dawn" instead of time
          if hours_today&.downcase&.include?("dawn")
            return [:opens_soon, "dawn"]
          else
            return [:opens_soon, opening_time]
          end
        end
      end
    end

    nil
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end
