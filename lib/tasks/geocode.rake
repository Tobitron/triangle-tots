namespace :geocode do
  desc "Re-geocode all evergreen activities from their addresses using Nominatim"
  task fix_coordinates: :environment do
    require "net/http"
    require "json"
    require "uri"

    activities = Activity.where.not(activity_type: "event").where.not(address: nil)
    puts "Geocoding #{activities.count} activities..."

    updated = 0
    skipped = 0

    activities.each do |activity|
      encoded = URI.encode_uri_component(activity.address)
      uri = URI("https://nominatim.openstreetmap.org/search?q=#{encoded}&format=json&limit=1")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Get.new(uri)
      req["User-Agent"] = "triangle-tots-geocode/1.0 (tobiasbkahn@gmail.com)"
      response = http.request(req)
      results = JSON.parse(response.body)

      if results.empty?
        puts "  SKIP (no result): #{activity.name} — #{activity.address}"
        skipped += 1
      else
        new_lat = results[0]["lat"].to_f.round(4)
        new_lng = results[0]["lon"].to_f.round(4)
        old_lat = activity.latitude&.to_f&.round(4)
        old_lng = activity.longitude&.to_f&.round(4)

        if new_lat == old_lat && new_lng == old_lng
          puts "  OK (unchanged): #{activity.name}"
        else
          puts "  UPDATE: #{activity.name}"
          puts "    old: #{old_lat}, #{old_lng}"
          puts "    new: #{new_lat}, #{new_lng}"
          activity.update_columns(latitude: new_lat, longitude: new_lng)
          updated += 1
        end
      end

      sleep 1.1  # Nominatim rate limit: 1 req/sec
    end

    puts "\nDone. #{updated} updated, #{skipped} skipped."
  end
end
