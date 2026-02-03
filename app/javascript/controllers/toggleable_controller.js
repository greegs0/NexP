import { Controller } from "@hotwired/stimulus"

/**
 * Controller de base pour les comportements toggle (dropdown, collapse, etc.)
 *
 * Usage:
 *   <div data-controller="toggleable" data-toggleable-open-value="false">
 *     <button data-action="toggleable#toggle">Toggle</button>
 *     <div data-toggleable-target="content" class="hidden">Content</div>
 *   </div>
 */
export default class extends Controller {
  static targets = ["content"]
  static values = {
    open: { type: Boolean, default: false },
    closeOnOutsideClick: { type: Boolean, default: true }
  }

  connect() {
    if (this.closeOnOutsideClickValue) {
      this.boundClickOutside = this.clickOutside.bind(this)
      document.addEventListener('click', this.boundClickOutside)
    }
    this.updateVisibility()
  }

  disconnect() {
    if (this.boundClickOutside) {
      document.removeEventListener('click', this.boundClickOutside)
    }
  }

  toggle(event) {
    if (event) {
      event.stopPropagation()
    }
    this.openValue = !this.openValue
  }

  open() {
    this.openValue = true
  }

  close() {
    this.openValue = false
  }

  clickOutside(event) {
    if (this.openValue && !this.element.contains(event.target)) {
      this.close()
    }
  }

  openValueChanged() {
    this.updateVisibility()
  }

  updateVisibility() {
    if (this.hasContentTarget) {
      this.contentTarget.classList.toggle('hidden', !this.openValue)
    }
  }
}
