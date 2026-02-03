import UIKit
import Turbo
import WebKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var navigationController: UINavigationController!

    private lazy var session: Session = {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = AppConfiguration.userAgent

        let session = Session(webViewConfiguration: configuration)
        session.delegate = self
        session.pathConfiguration = pathConfiguration

        return session
    }()

    private lazy var pathConfiguration = PathConfiguration(sources: [
        .file(Bundle.main.url(forResource: "TurboConfig", withExtension: "json")!)
    ])

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: windowScene)

        // Create tab bar controller
        let tabBarController = createTabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        // Configure bridges
        configureBridges()
    }

    private func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()

        // Now Tab
        let nowNav = createNavigationController(for: .now)
        nowNav.tabBarItem = UITabBarItem(
            title: "Now",
            image: UIImage(systemName: "clock.fill"),
            tag: 0
        )

        // Weekend Tab
        let weekendNav = createNavigationController(for: .weekend)
        weekendNav.tabBarItem = UITabBarItem(
            title: "Weekend",
            image: UIImage(systemName: "calendar"),
            tag: 1
        )

        // All Tab
        let allNav = createNavigationController(for: .all)
        allNav.tabBarItem = UITabBarItem(
            title: "All",
            image: UIImage(systemName: "list.bullet"),
            tag: 2
        )

        tabBarController.viewControllers = [nowNav, weekendNav, allNav]

        return tabBarController
    }

    private func createNavigationController(for view: ViewMode) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = false
        visit(url: AppConfiguration.activitiesURL(view: view.rawValue), in: navigationController)
        return navigationController
    }

    private func visit(url: URL, in navigationController: UINavigationController) {
        let viewController = VisitableViewController(url: url)
        navigationController.pushViewController(viewController, animated: false)
        session.visit(viewController)
    }

    private func configureBridges() {
        let contentController = session.webView.configuration.userContentController

        // Location Bridge
        let locationBridge = LocationBridge(session: session)
        contentController.add(locationBridge, name: "geolocation")

        // Storage Bridge
        let storageBridge = StorageBridge(session: session)
        contentController.add(storageBridge, name: "storage")
    }

    enum ViewMode: String {
        case now = "now"
        case weekend = "weekend"
        case all = "all"
    }
}

// MARK: - Session Delegate

extension SceneDelegate: SessionDelegate {
    func session(_ session: Session, didProposeVisit proposal: VisitProposal) {
        // Handle visit proposals
        visit(url: proposal.url, action: proposal.options.action, properties: proposal.properties)
    }

    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, error: Error) {
        print("Visit failed: \(error.localizedDescription)")

        // Show error alert
        if let viewController = visitable as? UIViewController {
            let alert = UIAlertController(
                title: "Connection Error",
                message: "Failed to load page. Please check your connection and try again.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                session.reload()
            })
            viewController.present(alert, animated: true)
        }
    }

    func sessionDidLoadWebView(_ session: Session) {
        // Configure web view settings
        session.webView.allowsBackForwardNavigationGestures = true
    }

    func session(_ session: Session, requestFor url: URL) -> URLRequest {
        var request = URLRequest(url: url)

        // Inject interactions as custom header
        let interactions = InteractionStore.shared.serializeForWeb()
        request.setValue(interactions, forHTTPHeaderField: "X-Native-Interactions")

        // Inject location as URL params
        if let location = LocationStore.shared.getLocation() {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            var queryItems = components?.queryItems ?? []

            // Only add location if not already present
            if !queryItems.contains(where: { $0.name == "home_lat" }) {
                queryItems.append(URLQueryItem(name: "home_lat", value: "\(location.latitude)"))
                queryItems.append(URLQueryItem(name: "home_lng", value: "\(location.longitude)"))
                components?.queryItems = queryItems

                if let modifiedURL = components?.url {
                    request.url = modifiedURL
                }
            }
        }

        return request
    }

    private func visit(url: URL, action: VisitAction, properties: PathProperties) {
        guard let navigationController = window?.rootViewController as? UITabBarController,
              let selectedNav = navigationController.selectedViewController as? UINavigationController else {
            return
        }

        let viewController = VisitableViewController(url: url)

        switch properties["presentation"] as? String {
        case "modal":
            let modalNav = UINavigationController(rootViewController: viewController)
            selectedNav.present(modalNav, animated: true)
            session.visit(viewController)

        case "replace":
            selectedNav.setViewControllers([viewController], animated: false)
            session.visit(viewController)

        default: // "push" or nil
            if action == .replace {
                selectedNav.setViewControllers([viewController], animated: false)
            } else {
                selectedNav.pushViewController(viewController, animated: true)
            }
            session.visit(viewController)
        }
    }
}
