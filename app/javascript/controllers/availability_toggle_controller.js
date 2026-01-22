import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["label", "checkbox"]
  static values = {
    userId: Number
  }

  toggle(event) {
    const checkbox = event.target
    const isAvailable = checkbox.checked

    // Disable during request
    checkbox.disabled = true
    checkbox.classList.add('opacity-60')

    fetch(`/users/${this.userIdValue}/toggle_availability`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({ available: isAvailable })
    })
    .then(response => response.json())
    .then(() => {
      if (this.hasLabelTarget) {
        this.labelTarget.textContent = isAvailable ? 'Disponible' : 'Non disponible'
      }
      // Show success feedback
      this.showFeedback(isAvailable ? 'Disponible' : 'Non disponible', 'success')
    })
    .catch(error => {
      console.error('Error:', error)
      // Revert checkbox on error
      checkbox.checked = !isAvailable
      this.showFeedback('Erreur de connexion', 'error')
    })
    .finally(() => {
      checkbox.disabled = false
      checkbox.classList.remove('opacity-60')
    })
  }

  showFeedback(message, type) {
    // Create toast notification
    const toast = document.createElement('div')
    toast.className = `fixed bottom-4 right-4 px-4 py-2 rounded-lg text-sm font-medium z-50 animate-fade-in-up ${
      type === 'success' ? 'bg-success text-white' : 'bg-destructive text-white'
    }`
    toast.textContent = message
    document.body.appendChild(toast)

    setTimeout(() => {
      toast.style.opacity = '0'
      toast.style.transform = 'translateY(10px)'
      setTimeout(() => toast.remove(), 300)
    }, 2000)
  }
}
