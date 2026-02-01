class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all

    # Extract home location from query params (or fall back to central Triangle)
    home_lat = params[:home_lat]&.to_f || 36.0014  # Durham
    home_lng = params[:home_lng]&.to_f || -78.9015

    # Store for views
    @home_location = { latitude: home_lat, longitude: home_lng }

    # Fetch weather forecast
    weather_data = WeatherService.fetch_forecast(home_lat, home_lng)
    @current_weather = weather_data[:current]

    # Analyze forecast for filtering strategy
    weather_strategy = WeatherService.analyze_rain_forecast(weather_data[:forecast])
    @weather_strategy = weather_strategy

    # Determine view mode: "now" or "all" (default to "now")
    @view_mode = params[:view] || "now"

    if @view_mode == "now"
      # Filter for "Now" feed
      @activities = ActivityFilter.filter_for_now(@activities, weather_strategy, Time.current)

      # Calculate status and distance for each activity
      @activities.each do |activity|
        status, status_time = activity.calculate_status
        activity.status = status
        activity.status_time = status_time
        activity.distance = activity.distance_from(home_lat, home_lng)
      end

      # Sort by distance (with weather penalty if needed)
      @activities = sort_with_weather_penalty(@activities, weather_strategy)
    else
      # "All" view - existing Milestone 2 behavior
      @activities.each do |activity|
        activity.distance = activity.distance_from(home_lat, home_lng)
      end
      @activities = @activities.sort_by { |a| [a.distance.nil? ? 1 : 0, a.distance || Float::INFINITY] }
    end
  end

  def show
    @activity = Activity.find(params[:id])
  end

  private

  def sort_with_weather_penalty(activities, weather_strategy)
    if weather_strategy == :deprioritize_outdoor
      # Indoor first (by distance), then outdoor (by distance)
      activities.sort_by do |a|
        [
          a.indoor ? 0 : 1,  # Indoor activities first
          a.distance.nil? ? 1 : 0,
          a.distance || Float::INFINITY
        ]
      end
    else
      # Normal distance sort
      activities.sort_by { |a| [a.distance.nil? ? 1 : 0, a.distance || Float::INFINITY] }
    end
  end
end
