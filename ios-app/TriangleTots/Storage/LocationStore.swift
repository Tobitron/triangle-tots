import Foundation
import CoreLocation

class LocationStore {
    static let shared = LocationStore()

    private let defaults = UserDefaults.standard
    private let locationKey = "triangleTots_homeLocation"

    private init() {}

    // MARK: - Public Methods

    func saveLocation(latitude: Double, longitude: Double) {
        let location = [
            "latitude": latitude,
            "longitude": longitude,
            "timestamp": Date().timeIntervalSince1970
        ] as [String : Any]

        defaults.set(location, forKey: locationKey)
        defaults.synchronize()

        print("Saved location: \(latitude), \(longitude)")
    }

    func getLocation() -> CLLocationCoordinate2D? {
        guard let location = defaults.dictionary(forKey: locationKey),
              let latitude = location["latitude"] as? Double,
              let longitude = location["longitude"] as? Double else {
            return nil
        }

        // Check if location is stale (older than 5 minutes)
        if let timestamp = location["timestamp"] as? TimeInterval {
            let age = Date().timeIntervalSince1970 - timestamp
            if age > 300 { // 5 minutes
                print("Location is stale, ignoring")
                return nil
            }
        }

        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func clearLocation() {
        defaults.removeObject(forKey: locationKey)
        defaults.synchronize()
    }
}
