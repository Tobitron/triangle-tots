import { Controller } from "@hotwired/stimulus"

// Auto-imports localStorage interactions when user logs in
export default class extends Controller {
  static values = {
    storageKey: { type: String, default: "triangleTots_activityInteractions" }
  }

  connect() {
    // Only run if user is logged in
    if (document.body.dataset.userLoggedIn === 'true') {
      this.importToAccount()
    } else {
      // For anonymous users, add interactions to URL if they exist
      this.addInteractionsToUrl()
    }
  }

  // Get storage
  getStorage() {
    const data = localStorage.getItem(this.storageKeyValue)
    if (!data) {
      return { version: "1.0", interactions: {} }
    }
    try {
      return JSON.parse(data)
    } catch (e) {
      console.error('Failed to parse interactions:', e)
      return { version: "1.0", interactions: {} }
    }
  }

  // Get CSRF token
  getCsrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content
  }

  // Import localStorage interactions to user account
  async importToAccount() {
    const storage = this.getStorage()
    if (Object.keys(storage.interactions).length === 0) return

    try {
      const response = await fetch('/interactions/import', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.getCsrfToken()
        },
        body: JSON.stringify({ interactions: storage.interactions })
      })

      if (response.ok) {
        // Clear localStorage after successful import
        localStorage.removeItem(this.storageKeyValue)
        console.log('Imported localStorage interactions to account')
      }
    } catch (e) {
      console.error('Failed to import interactions:', e)
    }
  }

  // Add interactions to URL for anonymous users
  addInteractionsToUrl() {
    const storage = this.getStorage()
    if (Object.keys(storage.interactions).length > 0) {
      const urlParams = new URLSearchParams(window.location.search)
      if (!urlParams.has('interactions')) {
        urlParams.set('interactions', JSON.stringify(storage.interactions))
        const newUrl = window.location.pathname + '?' + urlParams.toString()
        window.history.replaceState({}, '', newUrl)
      }
    }
  }
}
