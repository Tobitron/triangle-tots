class FixActivityCoordinates < ActiveRecord::Migration[8.1]
  def up
    require "net/http"
    require "json"
    require "uri"

    Activity.where(is_event: false).where.not(address: nil).each do |activity|
      encoded = URI.encode_uri_component(activity.address)
      uri = URI("https://nominatim.openstreetmap.org/search?q=#{encoded}&format=json&limit=1")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Get.new(uri)
      req["User-Agent"] = "triangle-tots-geocode/1.0 (tobiasbkahn@gmail.com)"
      results = JSON.parse(http.request(req).body)

      unless results.empty?
        activity.update_columns(
          latitude: results[0]["lat"].to_f.round(4),
          longitude: results[0]["lon"].to_f.round(4)
        )
      end

      sleep 1.1
    rescue => e
      Rails.logger.warn "Geocoding failed for #{activity.name}: #{e.message}"
    end
  end

  def down
  end
end
