import { Controller } from "@hotwired/stimulus"

// Controller pour la sélection multiple et actions en masse sur les notifications
export default class extends Controller {
  static targets = ["checkbox", "toolbar", "count", "card"]

  connect() {
    this.selectedIds = new Set()
    this.updateToolbar()
  }

  // Toggle la sélection d'une notification
  toggleSelect(event) {
    // Éviter de toggle si on clique sur un bouton ou lien
    if (event.target.closest('a, button, input[type="checkbox"]')) {
      if (event.target.matches('input[type="checkbox"]')) {
        this.handleCheckboxChange(event.target)
      }
      return
    }

    // Trouver la checkbox de cette card
    const card = event.currentTarget
    const checkbox = card.querySelector('input[type="checkbox"]')
    if (checkbox) {
      checkbox.checked = !checkbox.checked
      this.handleCheckboxChange(checkbox)
    }
  }

  handleCheckboxChange(checkbox) {
    const notificationId = checkbox.dataset.notificationId

    if (checkbox.checked) {
      this.selectedIds.add(notificationId)
    } else {
      this.selectedIds.delete(notificationId)
    }

    this.updateToolbar()
  }

  updateToolbar() {
    if (this.hasToolbarTarget) {
      if (this.selectedIds.size > 0) {
        this.toolbarTarget.classList.remove('hidden')
        this.countTarget.textContent = this.selectedIds.size
      } else {
        this.toolbarTarget.classList.add('hidden')
      }
    }
  }

  // Marquer comme lues
  async markAsRead() {
    if (this.selectedIds.size === 0) return

    try {
      const response = await this.performBulkAction('mark_read')
      if (response.ok) {
        window.location.reload()
      }
    } catch (error) {
      console.error('Erreur lors du marquage comme lu:', error)
      this.showError('Erreur lors du marquage des notifications')
    }
  }

  // Marquer comme non lues
  async markAsUnread() {
    if (this.selectedIds.size === 0) return

    try {
      const response = await this.performBulkAction('mark_unread')
      if (response.ok) {
        window.location.reload()
      }
    } catch (error) {
      console.error('Erreur lors du marquage comme non lu:', error)
      this.showError('Erreur lors du marquage des notifications')
    }
  }

  // Supprimer les sélectionnées
  async deleteSelected() {
    if (this.selectedIds.size === 0) return

    if (!confirm(`Supprimer ${this.selectedIds.size} notification(s) ?`)) {
      return
    }

    try {
      const response = await this.performBulkAction('delete')
      if (response.ok) {
        window.location.reload()
      }
    } catch (error) {
      console.error('Erreur lors de la suppression:', error)
      this.showError('Erreur lors de la suppression des notifications')
    }
  }

  // Effectuer une action en masse
  async performBulkAction(actionType) {
    return fetch('/notifications/bulk_action', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Accept': 'application/json'
      },
      body: JSON.stringify({
        action_type: actionType,
        notification_ids: Array.from(this.selectedIds)
      })
    })
  }

  showError(message) {
    // Toast d'erreur simple
    const toast = document.createElement('div')
    toast.className = 'fixed bottom-4 right-4 bg-destructive text-destructive-foreground px-4 py-3 rounded-lg shadow-lg animate-fade-in-up z-50'
    toast.textContent = message

    document.body.appendChild(toast)

    setTimeout(() => {
      toast.classList.add('opacity-0', 'transition-opacity')
      setTimeout(() => toast.remove(), 300)
    }, 3000)
  }
}
