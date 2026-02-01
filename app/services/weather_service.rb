class WeatherService
  include HTTParty
  base_uri "https://api.weatherapi.com/v1"

  CACHE_DURATION = 30.minutes
  RAIN_PROBABILITY_THRESHOLD = 60  # Percentage
  SIGNIFICANT_RAIN_HOURS_THRESHOLD = 3  # Hours
  API_KEY = ENV["WEATHER_API_KEY"]

  # Fetch weather forecast for a location
  # Returns: { current: {...}, forecast: [...], strategy: :hide_outdoor/:deprioritize_outdoor/:normal }
  def self.fetch_forecast(lat, lng)
    cache_key = "weather:#{lat.round(4)}:#{lng.round(4)}:#{Time.current.hour}"

    Rails.cache.fetch(cache_key, expires_in: CACHE_DURATION) do
      fetch_from_api(lat, lng)
    end
  rescue StandardError => e
    Rails.logger.error("Weather API error: #{e.message}")
    # Return default weather (assume good weather if API fails)
    default_weather_response
  end

  # Analyze forecast to determine filtering strategy
  # Returns: :hide_outdoor, :deprioritize_outdoor, or :normal
  def self.analyze_rain_forecast(forecast_hours)
    return :normal if forecast_hours.blank?

    # Count hours with precipitation probability > 60%
    rainy_hours = forecast_hours.count do |hour|
      hour[:precip_probability] > RAIN_PROBABILITY_THRESHOLD
    end

    if rainy_hours > SIGNIFICANT_RAIN_HOURS_THRESHOLD
      :hide_outdoor
    elsif rainy_hours > 0
      :deprioritize_outdoor
    else
      :normal
    end
  end

  private

  def self.fetch_from_api(lat, lng)
    return default_weather_response if API_KEY.blank?

    # Fetch current weather + forecast for 1 day
    response = get("/forecast.json", query: {
      key: API_KEY,
      q: "#{lat},#{lng}",
      days: 1,  # 1 day of forecast
      aqi: "no"  # We don't need air quality data
    })

    if response.success?
      parse_weather_response(response)
    else
      Rails.logger.error("Weather API HTTP error: #{response.code}")
      default_weather_response
    end
  end

  def self.parse_weather_response(response)
    current = response["current"]
    forecast_data = response["forecast"]["forecastday"]&.first
    day_forecast = forecast_data&.fetch("day", {})

    # Extract and round temperature values
    current_temp = current["temp_f"]
    high_temp = day_forecast["maxtemp_f"]
    low_temp = day_forecast["mintemp_f"]
    precip_chance = day_forecast["daily_chance_of_rain"] || day_forecast["daily_will_it_rain"] || 0

    {
      current: {
        condition: current["condition"]["text"],
        temp_f: current_temp ? current_temp.round : nil,
        high_f: high_temp ? high_temp.round : nil,
        low_f: low_temp ? low_temp.round : nil,
        precip_chance: precip_chance.to_i,
        precip_mm: current["precip_mm"],
        is_raining: current["precip_mm"] > 0,
        icon_url: current["condition"]["icon"]
      },
      forecast: parse_hourly_forecast(forecast_data),
      strategy: :normal  # Will be calculated by analyze_rain_forecast
    }
  end

  def self.parse_hourly_forecast(forecast_data)
    return [] if forecast_data.blank?

    current_hour = Time.current.hour
    forecast_data["hour"].select do |hour|
      hour_time = Time.parse(hour["time"])
      hour_time > Time.current && hour_time < 8.hours.from_now
    end.map do |hour|
      {
        time: Time.parse(hour["time"]),
        temp_f: hour["temp_f"],
        precip_probability: hour["chance_of_rain"],
        precip_mm: hour["precip_mm"],
        condition: hour["condition"]["text"]
      }
    end
  end

  def self.default_weather_response
    {
      current: {
        condition: "Unknown",
        temp_f: nil,
        high_f: nil,
        low_f: nil,
        precip_chance: 0,
        precip_mm: 0,
        is_raining: false,
        icon_url: nil
      },
      forecast: [],
      strategy: :normal
    }
  end
end
