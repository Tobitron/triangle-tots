class ActivitiesController < ApplicationController
  allow_unauthenticated_access

  def index
    @activities = Activity.excluding_thumbs_down_for(Current.user)

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

    # Get user interactions from database (logged in) or localStorage (anonymous)
    @interactions = load_interactions

    # Filter out thumbs-downed activities for anonymous users
    unless Current.user
      thumbs_down_ids = @interactions.select { |_, data| data['rating'] == -1 }.keys.map(&:to_i)
      @activities = @activities.where.not(id: thumbs_down_ids) if thumbs_down_ids.any?
    end

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

      # Filter out activities beyond 8 miles (museums exempt)
      @activities = ActivityFilter.filter_by_distance(@activities)

      # Sort by distance with personalization if interactions present
      if @interactions.present?
        @activities = RecommendationScorer.sort_with_scores(
          @activities,
          @interactions,
          home_lat,
          home_lng,
          weather_strategy
        )
      else
        # Fallback to original sorting without personalization
        @activities = sort_with_weather_penalty(@activities, weather_strategy)
      end
    elsif @view_mode == "weekend"
      # Filter for weekend events
      @activities = ActivityFilter.filter_for_weekend(@activities, Time.current.in_time_zone('Eastern Time (US & Canada)'))

      # Add distance calculations
      @activities.each do |activity|
        activity.distance = activity.distance_from(home_lat, home_lng)
      end

      # Filter out activities beyond 8 miles (museums exempt)
      @activities = ActivityFilter.filter_by_distance(@activities)

      # Sort by date (Saturday events first, then Sunday), then by distance
      @activities = @activities.sort_by do |a|
        [a.start_date.to_date, a.distance.nil? ? 1 : 0, a.distance || Float::INFINITY]
      end
    else
      # "All" view - existing Milestone 2 behavior
      @activities.each do |activity|
        activity.distance = activity.distance_from(home_lat, home_lng)
      end
      @activities = ActivityFilter.filter_by_distance(@activities)
      @activities = @activities.sort_by { |a| [a.distance.nil? ? 1 : 0, a.distance || Float::INFINITY] }
    end
  end

  def show
    @activity = Activity.find(params[:id])
  end

  private

  def load_interactions
    if Current.user
      # Load from database for logged-in users
      user_interactions = Current.user.user_interactions.includes(:activity)
      interactions = {}
      user_interactions.each do |ui|
        interactions[ui.activity_id.to_s] = {
          "rating" => ui.rating,
          "completions" => ui.completions || [],
          "lastCompleted" => ui.last_completed_at&.iso8601
        }
      end
      interactions
    else
      # Load from URL params for anonymous users (passed from localStorage)
      interactions_json = params[:interactions]
      interactions_json ? JSON.parse(interactions_json) : {}
    end
  end

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
