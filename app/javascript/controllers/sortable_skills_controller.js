import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

// Controller pour le drag & drop des compétences
export default class extends Controller {
  static targets = ["list"]
  static values = {
    url: String // URL pour sauvegarder l'ordre
  }

  connect() {
    this.sortable = Sortable.create(this.listTarget, {
      animation: 150,
      ghostClass: 'sortable-ghost',
      chosenClass: 'sortable-chosen',
      dragClass: 'sortable-drag',
      handle: '.drag-handle',
      onEnd: this.onSortEnd.bind(this)
    })
  }

  disconnect() {
    if (this.sortable) {
      this.sortable.destroy()
    }
  }

  async onSortEnd(event) {
    const items = this.listTarget.querySelectorAll('[data-skill-id]')
    const skillIds = Array.from(items).map(item => item.dataset.skillId)

    try {
      const response = await fetch(this.urlValue, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        },
        body: JSON.stringify({ skill_ids: skillIds })
      })

      if (!response.ok) {
        throw new Error('Failed to save order')
      }

      // Feedback visuel de succès (optionnel)
      this.showSaveIndicator()
    } catch (error) {
      console.error('Error saving skill order:', error)
      // Restaurer l'ordre précédent si erreur
      this.sortable.sort(this.previousOrder || [])
    }
  }

  showSaveIndicator() {
    const indicator = document.createElement('div')
    indicator.className = 'fixed bottom-4 right-4 bg-primary text-primary-foreground px-4 py-2 rounded-lg shadow-lg text-sm font-medium animate-fade-in-up'
    indicator.textContent = 'Ordre sauvegardé'
    document.body.appendChild(indicator)

    setTimeout(() => {
      indicator.classList.add('opacity-0', 'transition-opacity')
      setTimeout(() => indicator.remove(), 300)
    }, 2000)
  }
}
