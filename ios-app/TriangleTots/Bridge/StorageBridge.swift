import WebKit
import Turbo

class StorageBridge: NSObject, WKScriptMessageHandler {
    weak var session: Session?

    init(session: Session) {
        self.session = session
    }

    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any],
              let action = body["action"] as? String,
              let data = body["data"] as? [String: Any] else {
            return
        }

        switch action {
        case "rate":
            handleRate(data: data)
        case "markDone":
            handleMarkDone(data: data)
        default:
            break
        }
    }

    private func handleRate(data: [String: Any]) {
        guard let activityId = data["activityId"] as? Int,
              let rating = data["rating"] as? Int else {
            return
        }

        print("Saving rating: activity \(activityId), rating \(rating)")

        // Save to UserDefaults (native storage)
        InteractionStore.shared.saveRating(activityId: activityId, rating: rating)

        // Trigger reload via Turbo
        DispatchQueue.main.async {
            self.session?.reload()
        }
    }

    private func handleMarkDone(data: [String: Any]) {
        guard let activityId = data["activityId"] as? Int else {
            return
        }

        let reloadToNow = data["reloadToNow"] as? Bool ?? false

        print("Marking as done: activity \(activityId)")

        // Save to UserDefaults (native storage)
        InteractionStore.shared.markDone(activityId: activityId)

        // Trigger reload or navigate to "now" view
        DispatchQueue.main.async {
            if reloadToNow {
                // Navigate to "now" view
                let url = AppConfiguration.activitiesURL(view: "now")
                if let location = LocationStore.shared.getLocation() {
                    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
                    components.queryItems = (components.queryItems ?? []) + [
                        URLQueryItem(name: "home_lat", value: "\(location.latitude)"),
                        URLQueryItem(name: "home_lng", value: "\(location.longitude)")
                    ]
                    if let modifiedURL = components.url {
                        self.session?.visit(VisitableViewController(url: modifiedURL))
                    }
                } else {
                    self.session?.visit(VisitableViewController(url: url))
                }
            } else {
                self.session?.reload()
            }
        }
    }
}
