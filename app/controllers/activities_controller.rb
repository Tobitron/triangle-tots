class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all

    # Extract home location from query params
    home_lat = params[:home_lat]&.to_f
    home_lng = params[:home_lng]&.to_f

    if home_lat.present? && home_lng.present?
      # Store home location for use in views
      @home_location = { latitude: home_lat, longitude: home_lng }

      # Calculate distance for each activity
      @activities.each do |activity|
        activity.distance = activity.distance_from(home_lat, home_lng)
      end

      # Sort: activities with distance first (ascending), then activities without distance
      @activities = @activities.sort_by { |a| [a.distance.nil? ? 1 : 0, a.distance || Float::INFINITY] }
    else
      # No home location provided, sort alphabetically
      @activities = @activities.order(:name)
    end
  end

  def show
    @activity = Activity.find(params[:id])
  end
end
