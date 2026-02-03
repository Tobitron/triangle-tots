import Foundation

class InteractionStore {
    static let shared = InteractionStore()

    private let defaults = UserDefaults.standard
    private let interactionsKey = "triangleTots_interactions"

    private init() {}

    // MARK: - Data Structure

    struct Interaction: Codable {
        var rating: Int?
        var completions: [String]
        var lastCompleted: String?
        var updatedAt: String?
    }

    // MARK: - Public Methods

    func saveRating(activityId: Int, rating: Int) {
        var interactions = loadInteractions()

        if interactions["\(activityId)"] == nil {
            interactions["\(activityId)"] = Interaction(
                rating: nil,
                completions: [],
                lastCompleted: nil,
                updatedAt: nil
            )
        }

        interactions["\(activityId)"]?.rating = rating
        interactions["\(activityId)"]?.updatedAt = ISO8601DateFormatter().string(from: Date())

        saveInteractions(interactions)
    }

    func markDone(activityId: Int) {
        var interactions = loadInteractions()

        if interactions["\(activityId)"] == nil {
            interactions["\(activityId)"] = Interaction(
                rating: nil,
                completions: [],
                lastCompleted: nil,
                updatedAt: nil
            )
        }

        let now = ISO8601DateFormatter().string(from: Date())
        interactions["\(activityId)"]?.completions.append(now)
        interactions["\(activityId)"]?.lastCompleted = now
        interactions["\(activityId)"]?.updatedAt = now

        saveInteractions(interactions)
    }

    func loadInteractions() -> [String: Interaction] {
        guard let data = defaults.data(forKey: interactionsKey) else {
            return [:]
        }

        do {
            let decoder = JSONDecoder()
            let interactions = try decoder.decode([String: Interaction].self, from: data)
            return interactions
        } catch {
            print("Error decoding interactions: \(error)")
            return [:]
        }
    }

    private func saveInteractions(_ interactions: [String: Interaction]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(interactions)
            defaults.set(data, forKey: interactionsKey)
            defaults.synchronize()
        } catch {
            print("Error encoding interactions: \(error)")
        }
    }

    // Serialize for passing to web via HTTP headers
    func serializeForWeb() -> String {
        let interactions = loadInteractions()

        // Convert to JSON dictionary matching web format
        var webFormat: [String: [String: Any]] = [:]
        for (activityId, interaction) in interactions {
            webFormat[activityId] = [
                "rating": interaction.rating as Any,
                "completions": interaction.completions,
                "lastCompleted": interaction.lastCompleted as Any,
                "updatedAt": interaction.updatedAt as Any
            ]
        }

        guard let data = try? JSONSerialization.data(withJSONObject: webFormat),
              let json = String(data: data, encoding: .utf8) else {
            return "{}"
        }

        return json
    }

    func clearInteractions() {
        defaults.removeObject(forKey: interactionsKey)
        defaults.synchronize()
    }
}
