import Foundation

struct AppConfiguration {
    // MARK: - Server URLs

    #if DEBUG
    // Use localhost for development
    static let baseURL = URL(string: "http://localhost:3000")!
    #else
    // Use your production URL here
    static let baseURL = URL(string: "https://your-production-url.com")!
    #endif

    // MARK: - Routes

    static var rootURL: URL {
        return activitiesURL(view: "now")
    }

    static func activitiesURL(view: String) -> URL {
        var components = URLComponents(url: baseURL.appendingPathComponent("activities"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "view", value: view)]
        return components.url!
    }

    static func activityURL(id: Int) -> URL {
        return baseURL.appendingPathComponent("activities/\(id)")
    }

    // MARK: - App Info

    static let appName = "Triangle Tots"
    static let userAgent = "Turbo Native iOS"
}
