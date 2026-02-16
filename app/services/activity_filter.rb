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

  # Filter activities for upcoming weekend events
  # Returns only events (is_event: true) happening on next Sat/Sun
  def self.filter_for_weekend(activities, current_time = Time.current)
    # Find next Saturday and Sunday
    today = current_time.to_date
    days_until_saturday = (6 - today.wday) % 7
    days_until_saturday = 7 if days_until_saturday == 0 && today.wday != 6 # If today is not Saturday, go to next week

    next_saturday = today + days_until_saturday.days
    next_sunday = next_saturday + 1.day

    # Handle edge case: if today IS Saturday, use today and tomorrow
    if today.saturday?
      next_saturday = today
      next_sunday = today + 1.day
    elsif today.sunday?
      # If today is Sunday, show next weekend (6-7 days away)
      next_saturday = today + 6.days
      next_sunday = today + 7.days
    end

    # Filter to events only, happening on next Sat or Sun
    activities.select do |activity|
      activity.is_event &&
      activity.start_date.present? &&
      (activity.start_date.to_date == next_saturday || activity.start_date.to_date == next_sunday)
    end
  end

  # Filter activities beyond 15 miles (museums are exempt)
  MAX_DISTANCE_MILES = 15

  def self.filter_by_distance(activities)
    activities.select do |activity|
      activity.activity_type == "museum" ||
        activity.distance.nil? ||
        activity.distance <= MAX_DISTANCE_MILES
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

  # When "Now" feed is empty, relax weather filter but keep the same time constraint
  # Only show activities that are opening within 2 hours (same definition of "soon")
  def self.relax_filters_for_empty_state(activities, current_time)
    activities.select do |activity|
      !activity.open_at?(current_time) && activity.opens_within?(2).present?
    end
  end
end
