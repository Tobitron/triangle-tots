import { Controller } from "@hotwired/stimulus"

// Manages user location (browser or native app)
export default class extends Controller {
  static values = {
    storageKey: { type: String, default: "triangleTots_homeLocation" }
  }

  connect() {
    // Check if location exists in storage
    if (!this.hasLocation()) {
      // No location stored, automatically request it
      this.requestGeolocation()
    } else {
      // Location exists, add it to current URL if not already present
      const urlParams = new URLSearchParams(window.location.search)
      if (!urlParams.has('home_lat') || !urlParams.has('home_lng')) {
        this.reloadWithLocation()
      }
    }
  }

  // Check if we're running in native app
  isNativeApp() {
    return window.webkit?.messageHandlers?.geolocation
  }

  // Check if location exists in localStorage
  hasLocation() {
    return localStorage.getItem(this.storageKeyValue) !== null
  }

  // Get location from localStorage
  getLocation() {
    const data = localStorage.getItem(this.storageKeyValue)
    return data ? JSON.parse(data) : null
  }

  // Save location to localStorage
  saveLocation(latitude, longitude) {
    const data = { latitude, longitude }
    localStorage.setItem(this.storageKeyValue, JSON.stringify(data))
  }

  // Clear location from localStorage
  clearLocation() {
    localStorage.removeItem(this.storageKeyValue)
    this.requestGeolocation()
  }

  // Request geolocation (browser or native)
  requestGeolocation() {
    if (this.isNativeApp()) {
      this.requestNativeLocation()
    } else {
      this.requestBrowserLocation()
    }
  }

  // Request location from native iOS app
  requestNativeLocation() {
    window.webkit.messageHandlers.geolocation.postMessage({
      action: "request"
    })
  }

  // Request location from browser
  requestBrowserLocation() {
    if (!navigator.geolocation) {
      alert('Geolocation is not supported by your browser.')
      return
    }

    navigator.geolocation.getCurrentPosition(
      (position) => {
        const { latitude, longitude } = position.coords
        this.saveLocation(latitude, longitude)
        this.reloadWithLocation()
      },
      (error) => {
        let errorMsg = 'Unable to get your location. '
        if (error.code === error.PERMISSION_DENIED) {
          errorMsg += 'Please enable location access in your browser settings and try again.'
        } else if (error.code === error.POSITION_UNAVAILABLE) {
          errorMsg += 'Location information is unavailable.'
        } else if (error.code === error.TIMEOUT) {
          errorMsg += 'The request to get your location timed out.'
        } else {
          errorMsg += 'An unknown error occurred.'
        }
        alert(errorMsg)
      },
      {
        enableHighAccuracy: false,
        timeout: 10000,
        maximumAge: 300000 // 5 minutes
      }
    )
  }

  // Called by iOS app via evaluateJavaScript when location is received
  receiveLocation(latitude, longitude) {
    this.saveLocation(latitude, longitude)
    this.reloadWithLocation()
  }

  // Reload page with location parameters
  reloadWithLocation() {
    const location = this.getLocation()
    if (location) {
      const url = new URL(window.location.href)
      url.searchParams.set('home_lat', location.latitude)
      url.searchParams.set('home_lng', location.longitude)
      window.location.href = url.toString()
    }
  }

  // Action for "Change Location" button
  changeLocation(event) {
    event.preventDefault()
    this.clearLocation()
  }
}
