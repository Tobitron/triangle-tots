import { Controller } from "@hotwired/stimulus"

// Manages user ratings and activity completions
// Uses backend API for logged-in users, localStorage for anonymous users
export default class extends Controller {
  static values = {
    activityId: Number,
    storageKey: { type: String, default: "triangleTots_activityInteractions" },
    loggedIn: Boolean
  }

  static targets = ["thumbsUp", "thumbsDown", "markDone"]

  connect() {
    // Update button states on load for anonymous users
    if (!this.loggedInValue) {
      this.updateButtonStates()
    }
  }

  // Check if running in native app
  isNativeApp() {
    return window.webkit?.messageHandlers?.storage
  }

  // Get CSRF token for API requests
  getCsrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content
  }

  // Initialize storage structure (for anonymous users)
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

  saveStorage(data) {
    localStorage.setItem(this.storageKeyValue, JSON.stringify(data))
  }

  // Rate an activity (1 = thumbs up, -1 = thumbs down)
  async rate(event) {
    const rating = parseInt(event.params.rating)

    if (this.isNativeApp()) {
      this.saveToNativeStorage('rate', {
        activityId: this.activityIdValue,
        rating
      })
    } else if (this.loggedInValue) {
      await this.saveToBackend('rate', { activity_id: this.activityIdValue, rating })
    } else {
      this.saveToLocalStorage('rate', { activityId: this.activityIdValue, rating })
    }
  }

  // Mark activity as done
  async markDone(event) {
    const reloadToNow = event.params.reloadToNow || false

    if (this.isNativeApp()) {
      this.saveToNativeStorage('markDone', {
        activityId: this.activityIdValue,
        reloadToNow
      })
    } else if (this.loggedInValue) {
      await this.saveToBackend('markDone', { activity_id: this.activityIdValue }, reloadToNow)
    } else {
      this.saveToLocalStorage('markDone', { activityId: this.activityIdValue }, reloadToNow)
    }
  }

  // Save to native storage via message handler
  saveToNativeStorage(action, data) {
    window.webkit.messageHandlers.storage.postMessage({
      action,
      data
    })
    // Native app will handle reload
  }

  // Save to backend API (logged-in users)
  async saveToBackend(action, data, reloadToNow = false) {
    const endpoint = action === 'rate' ? '/interactions/rate' : '/interactions/mark_done'

    try {
      const response = await fetch(endpoint, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.getCsrfToken()
        },
        body: JSON.stringify(data)
      })

      if (response.ok) {
        if (reloadToNow) {
          const urlParams = new URLSearchParams(window.location.search)
          urlParams.set('view', 'now')
          window.location.href = '/activities?' + urlParams.toString()
        } else {
          window.location.reload()
        }
      }
    } catch (e) {
      console.error(`Failed to save ${action}:`, e)
    }
  }

  // Save to localStorage (anonymous users)
  saveToLocalStorage(action, data, reloadToNow = false) {
    const storage = this.getStorage()
    const activityId = data.activityId.toString()

    if (!storage.interactions[activityId]) {
      storage.interactions[activityId] = {
        rating: null,
        completions: [],
        lastCompleted: null,
        updatedAt: null
      }
    }

    if (action === 'rate') {
      storage.interactions[activityId].rating = data.rating
      storage.interactions[activityId].updatedAt = new Date().toISOString()

      this.saveStorage(storage)

      // Always reload for thumbs down to hide the activity immediately
      if (data.rating === -1) {
        this.reloadWithInteractions()
      } else {
        this.updateButtonStates()
      }
    } else if (action === 'markDone') {
      const now = new Date().toISOString()
      storage.interactions[activityId].completions.push(now)
      storage.interactions[activityId].lastCompleted = now
      storage.interactions[activityId].updatedAt = now

      this.saveStorage(storage)

      if (reloadToNow) {
        const urlParams = new URLSearchParams(window.location.search)
        urlParams.set('view', 'now')
        window.location.href = '/activities?' + urlParams.toString()
      } else {
        this.reloadWithInteractions()
      }
    }
  }

  // Reload page with interactions parameter (for anonymous users)
  reloadWithInteractions() {
    const storage = this.getStorage()
    const urlParams = new URLSearchParams(window.location.search)
    urlParams.set('interactions', JSON.stringify(storage.interactions))
    window.location.href = '/activities?' + urlParams.toString()
  }

  // Update button visual states without reload
  updateButtonStates() {
    const storage = this.getStorage()
    const interaction = storage.interactions[this.activityIdValue.toString()]

    if (!interaction) return

    // Update thumbs up/down states
    if (this.hasThumbsUpTarget) {
      if (interaction.rating === 1) {
        this.thumbsUpTarget.classList.add('bg-green-100', 'border-green-500')
        this.thumbsUpTarget.classList.remove('border-gray-300')
      } else {
        this.thumbsUpTarget.classList.remove('bg-green-100', 'border-green-500')
        this.thumbsUpTarget.classList.add('border-gray-300')
      }
    }

    if (this.hasThumbsDownTarget) {
      if (interaction.rating === -1) {
        this.thumbsDownTarget.classList.add('bg-red-100', 'border-red-500')
        this.thumbsDownTarget.classList.remove('border-gray-300')
      } else {
        this.thumbsDownTarget.classList.remove('bg-red-100', 'border-red-500')
        this.thumbsDownTarget.classList.add('border-gray-300')
      }
    }

    if (this.hasMarkDoneTarget) {
      if (interaction.lastCompleted) {
        this.markDoneTarget.classList.add('bg-blue-100', 'border-blue-500')
        this.markDoneTarget.classList.remove('border-gray-300')
      } else {
        this.markDoneTarget.classList.remove('bg-blue-100', 'border-blue-500')
        this.markDoneTarget.classList.add('border-gray-300')
      }
    }
  }
}
