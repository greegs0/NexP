import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon"]
  static values = {
    open: { type: Boolean, default: true },
    key: String // Pour persister l'état dans localStorage
  }

  connect() {
    // Restaurer l'état depuis localStorage si une clé est définie
    if (this.hasKeyValue) {
      const saved = localStorage.getItem(`collapse_${this.keyValue}`)
      if (saved !== null) {
        this.openValue = saved === 'true'
      }
    }
    this.updateUI()
  }

  toggle() {
    this.openValue = !this.openValue
    this.updateUI()

    // Sauvegarder l'état
    if (this.hasKeyValue) {
      localStorage.setItem(`collapse_${this.keyValue}`, this.openValue)
    }
  }

  updateUI() {
    if (this.hasContentTarget) {
      if (this.openValue) {
        this.contentTarget.style.maxHeight = this.contentTarget.scrollHeight + 'px'
        this.contentTarget.style.opacity = '1'
      } else {
        this.contentTarget.style.maxHeight = '0'
        this.contentTarget.style.opacity = '0'
      }
    }

    if (this.hasIconTarget) {
      this.iconTarget.style.transform = this.openValue ? 'rotate(0deg)' : 'rotate(-90deg)'
    }
  }
}
