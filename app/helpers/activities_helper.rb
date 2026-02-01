module ActivitiesHelper
  def activity_icon(activity_type, size: 64)
    icon_mapping = {
      'library' => 'icon-library.png',
      'museum' => 'icon-library.png',
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
end
