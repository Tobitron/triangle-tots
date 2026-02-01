class ActivityFilter
  # Filter activities for "Now" feed
  # Returns: Array of activities that match the filters
  def self.filter_for_now(activities, weather_strategy, current_time = Time.current)
    # First, filter by hours (open now OR opens within 2 hours)
    time_filtered = activities.select do |activity|
      activity.open_at?(current_time) || activity.opens_within?(2).present?
    end

    # Then, apply weather filtering based on strategy
    weather_filtered = apply_weather_filter(time_filtered, weather_strategy)

    # If no activities match, relax filters to show "opens soon" activities
    if weather_filtered.empty?
      relax_filters_for_empty_state(activities, current_time)
    else
      weather_filtered
    end
  end

  # Apply weather-based filtering
  # :hide_outdoor - remove all outdoor activities
  # :deprioritize_outdoor - keep outdoor activities but don't filter them out
  # :normal - no weather filtering
  def self.apply_weather_filter(activities, weather_strategy)
    case weather_strategy
    when :hide_outdoor
      # Filter out outdoor activities completely
      activities.select(&:indoor)
    when :deprioritize_outdoor, :normal
      # Keep all activities (deprioritization happens in sorting)
      activities
    else
      activities
    end
  end

  # When "Now" feed is empty, relax filters to show activities opening soon
  # Show next 5-10 activities that will open in the future (today or tomorrow)
  def self.relax_filters_for_empty_state(activities, current_time)
    # Find activities that will open later today or tomorrow
    future_activities = activities.select do |activity|
      !activity.open_at?(current_time) &&
        (activity.opens_within?(12).present? || will_open_tomorrow?(activity))
    end

    # Take up to 10 activities
    future_activities.take(10)
  end

  # Check if activity will open tomorrow (for evening edge case)
  def self.will_open_tomorrow?(activity)
    # If it's evening and activity is closed, it might open tomorrow
    tomorrow = (Time.current + 1.day).beginning_of_day
    tomorrow_day_name = tomorrow.strftime("%A").downcase
    tomorrow_hours = activity.hours[tomorrow_day_name]

    return false if tomorrow_hours.blank? || tomorrow_hours.downcase == "closed"

    # Check if it opens anytime tomorrow
    opening_time = HoursParser.get_opening_time(tomorrow_hours)
    opening_time.present?
  end
end
