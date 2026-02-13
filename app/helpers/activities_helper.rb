module ActivitiesHelper
  def activity_icon(activity_type, size: 64)
    # Handle nil activity_type
    return image_tag('icon-library.png', width: size, height: size, alt: "Activity icon", class: "activity-icon") if activity_type.nil?

    icon_mapping = {
      'library' => 'icon-library.png',
      'museum' => 'icon-museum.png',
      'class_activity' => 'icon-library.png',
      'restaurant' => 'icon-library.png',

      'park' => 'icon-park.png',
      'splash_pad' => 'icon-park.png',
      'farm' => 'icon-park.png',
      'nature_trail' => 'icon-park.png',

      'playground' => 'icon-playground.png',
      'indoor_play' => 'icon-playground.png',
      'event' => 'icon-playground.png'
    }

    icon_file = icon_mapping[activity_type] || 'icon-library.png'

    image_tag(icon_file,
              width: size,
              height: size,
              alt: "#{activity_type.tr('_', ' ').titleize} icon",
              class: "activity-icon")
  end

  def format_distance(distance_in_miles)
    return "Distance unknown" if distance_in_miles.nil?

    "#{distance_in_miles.round(1)} mi away"
  end

  def format_status_badge(activity)
    return unless activity.status

    case activity.status
    when :open
      content_tag :span, "Open until #{activity.status_time}",
                  class: "px-2 py-1 bg-green-100 text-green-800 text-xs font-medium rounded"
    when :closing_soon
      content_tag :span, "Closing soon",
                  class: "px-2 py-1 bg-yellow-100 text-yellow-800 text-xs font-medium rounded"
    when :opens_soon
      content_tag :span, "Opens at #{activity.status_time}",
                  class: "px-2 py-1 bg-blue-100 text-blue-800 text-xs font-medium rounded"
    end
  end

  def weather_icon(condition)
    return "🌤️" if condition.blank?

    # Map weather conditions to emoji icons
    case condition.downcase
    when /sun/, /clear/ then "☀️"
    when /cloud/ then "☁️"
    when /rain/ then "🌧️"
    when /snow/ then "❄️"
    when /storm/ then "⛈️"
    else "🌤️"
    end
  end

  def weather_summary(current_weather, weather_strategy)
    return "" if current_weather.blank?

    condition = current_weather[:condition]
    temp = current_weather[:temp_f]
    high = current_weather[:high_f]
    low = current_weather[:low_f]
    precip_chance = current_weather[:precip_chance]

    parts = []

    # Part 1: Icon + Condition and current temp (e.g., "☀️ Sunny 33°")
    condition_with_temp = []
    # Add weather icon
    condition_with_temp << weather_icon(condition) if condition.present?
    # Adjust message based on weather strategy
    condition_text = case weather_strategy
    when :hide_outdoor
      "Rain expected - showing indoor activities only"
    when :deprioritize_outdoor
      "Light rain in forecast - indoor activities prioritized"
    else
      condition
    end
    condition_with_temp << condition_text if condition_text.present?
    condition_with_temp << "#{temp}°" if temp
    parts << condition_with_temp.join(" ") if condition_with_temp.any?

    # Part 2: Today's high and low (e.g., "Today's high: 36° low: 17°")
    if high && low
      parts << "Today's high: #{high}° low: #{low}°"
    elsif high
      parts << "Today's high: #{high}°"
    elsif low
      parts << "Today's low: #{low}°"
    end

    # Part 3: Precipitation chance (e.g., "64% chance of rain")
    if precip_chance && precip_chance > 0
      parts << "#{precip_chance}% chance of rain"
    end

    parts.join(" • ")
  end
end
