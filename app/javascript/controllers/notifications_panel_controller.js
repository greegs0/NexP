import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["badge", "panel", "list"]
  static values = {
    url: String
  }

  connect() {
    this.isOpen = false
    this.updateUnreadCount()
    // Rafraîchir toutes les 30 secondes
    this.intervalId = setInterval(() => {
      this.updateUnreadCount()
    }, 30000)

    // Fermer le panneau en cliquant ailleurs
    this.boundClickOutside = this.clickOutside.bind(this)
    document.addEventListener('click', this.boundClickOutside)
  }

  disconnect() {
    if (this.intervalId) {
      clearInterval(this.intervalId)
    }
    document.removeEventListener('click', this.boundClickOutside)
  }

  toggle(event) {
    event.stopPropagation()
    this.isOpen = !this.isOpen

    if (this.isOpen) {
      this.panelTarget.classList.remove('hidden')
      this.loadNotifications()
    } else {
      this.panelTarget.classList.add('hidden')
    }
  }

  clickOutside(event) {
    if (this.isOpen && !this.element.contains(event.target)) {
      this.isOpen = false
      this.panelTarget.classList.add('hidden')
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

  async loadNotifications() {
    try {
      const response = await fetch('/notifications?limit=5', {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })

      if (response.ok) {
        const notifications = await response.json()
        this.renderNotifications(notifications)
      }
    } catch (error) {
      console.error('Erreur lors du chargement des notifications:', error)
      this.listTarget.innerHTML = `
        <div class="p-4 text-center text-sm text-muted-foreground">
          Erreur de chargement
        </div>
      `
    }
  }

  renderNotifications(notifications) {
    if (!notifications || notifications.length === 0) {
      this.listTarget.innerHTML = `
        <div class="p-4 text-center text-sm text-muted-foreground">
          Aucune notification
        </div>
      `
      return
    }

    const html = notifications.map(notif => {
      // Notification de badge - affiche la description directement
      if (notif.action === 'badge_earned' && notif.badge_name) {
        const description = notif.badge_description || `Tu as débloqué le badge ${notif.badge_name}!`
        return `
          <div class="flex items-start gap-3 p-3 border-b border-border last:border-0 ${notif.read ? 'opacity-60' : ''}">
            <div class="w-8 h-8 bg-yellow-500/20 text-yellow-500 rounded-full flex items-center justify-center flex-shrink-0">
              <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
              </svg>
            </div>
            <div class="flex-1 min-w-0">
              <p class="text-sm text-foreground">
                <span class="text-muted-foreground">Badge:</span>
                <span class="font-medium text-primary">${this.escapeHtml(notif.badge_name)}</span>
              </p>
              <p class="text-xs text-muted-foreground mt-1">${this.escapeHtml(description)}</p>
              <p class="text-xs text-muted-foreground/60 mt-0.5">${notif.time_ago}</p>
            </div>
            ${!notif.read ? '<div class="w-2 h-2 bg-yellow-500 rounded-full flex-shrink-0 mt-2"></div>' : ''}
          </div>
        `
      }

      // Notification standard
      return `
        <a href="/notifications" class="flex items-start gap-3 p-3 hover:bg-secondary/50 transition-colors border-b border-border last:border-0 ${notif.read ? 'opacity-60' : ''}">
          <div class="w-8 h-8 bg-primary/20 text-primary rounded-full flex items-center justify-center flex-shrink-0 text-xs font-bold">
            ${notif.actor_initial || '?'}
          </div>
          <div class="flex-1 min-w-0">
            <p class="text-sm text-foreground">
              <span class="font-medium">${this.escapeHtml(notif.actor_name || 'Quelqu\'un')}</span>
              <span class="text-muted-foreground">${this.escapeHtml(notif.message)}</span>
            </p>
            <p class="text-xs text-muted-foreground mt-0.5">${notif.time_ago}</p>
          </div>
          ${!notif.read ? '<div class="w-2 h-2 bg-primary rounded-full flex-shrink-0 mt-2"></div>' : ''}
        </a>
      `
    }).join('')

    this.listTarget.innerHTML = html
  }

  escapeHtml(text) {
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
  }
}
