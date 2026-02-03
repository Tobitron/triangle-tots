import WebKit
import CoreLocation
import Turbo

class LocationBridge: NSObject, WKScriptMessageHandler {
    weak var session: Session?
    private let locationManager = CLLocationManager()
    private var pendingCallback: (() -> Void)?

    init(session: Session) {
        self.session = session
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any],
              let action = body["action"] as? String else {
            return
        }

        switch action {
        case "request":
            requestLocation()
        default:
            break
        }
    }

    private func requestLocation() {
        // Check authorization status
        let status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }

        switch status {
        case .notDetermined:
            // Request authorization
            locationManager.requestWhenInUseAuthorization()
            // Location will be requested after authorization in delegate method

        case .authorizedWhenInUse, .authorizedAlways:
            // Already authorized, request location
            locationManager.requestLocation()

        case .denied, .restricted:
            // Show alert to user
            showLocationPermissionAlert()

        @unknown default:
            break
        }
    }

    private func showLocationPermissionAlert() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                return
            }

            let alert = UIAlertController(
                title: "Location Access Required",
                message: "Triangle Tots needs your location to show nearby activities. Please enable location access in Settings.",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            })

            rootViewController.present(alert, animated: true)
        }
    }

    private func sendLocationToWeb(latitude: Double, longitude: Double) {
        // Save to local storage
        LocationStore.shared.saveLocation(latitude: latitude, longitude: longitude)

        // Send to web via JavaScript
        let script = """
        if (window.Stimulus) {
            const locationController = window.Stimulus.getControllerForElementAndIdentifier(
                document.body,
                'location'
            );
            if (locationController) {
                locationController.receiveLocation(\(latitude), \(longitude));
            }
        }
        """

        session?.webView.evaluateJavaScript(script) { _, error in
            if let error = error {
                print("Error sending location to web: \(error)")
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationBridge: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = manager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }

        // If just authorized, request location
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager,
                        didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        print("Received location: \(latitude), \(longitude)")
        sendLocationToWeb(latitude: latitude, longitude: longitude)
    }

    func locationManager(_ manager: CLLocationManager,
                        didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")

        // Show alert to user
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                return
            }

            let alert = UIAlertController(
                title: "Location Error",
                message: "Unable to get your location. Please try again.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))

            rootViewController.present(alert, animated: true)
        }
    }
}
