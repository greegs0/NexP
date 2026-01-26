import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["badge"]
  static values = {
    url: String
  }

  connect() {
    this.updateUnreadCount()
    // Rafraîchir toutes les 30 secondes
    this.intervalId = setInterval(() => {
      this.updateUnreadCount()
    }, 30000)
  }

  disconnect() {
    if (this.intervalId) {
      clearInterval(this.intervalId)
    }
  }

  async updateUnreadCount() {
    try {
      const response = await fetch(this.urlValue, {
        headers: {
          'Accept': 'application/json'
        }
      })

      if (response.ok) {
        const data = await response.json()
        this.updateBadge(data.count)
      }
    } catch (error) {
      console.error('Erreur lors de la récupération des notifications:', error)
    }
  }

  updateBadge(count) {
    if (count > 0) {
      this.badgeTarget.textContent = count > 99 ? '99+' : count
      this.badgeTarget.classList.remove('hidden')
    } else {
      this.badgeTarget.classList.add('hidden')
    }
  }
}
