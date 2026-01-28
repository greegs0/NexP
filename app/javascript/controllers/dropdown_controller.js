import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.isOpen = false
    this.boundClickOutside = this.clickOutside.bind(this)
    document.addEventListener('click', this.boundClickOutside)
  }

  disconnect() {
    document.removeEventListener('click', this.boundClickOutside)
  }

  toggle(event) {
    event.stopPropagation()
    this.isOpen = !this.isOpen

    if (this.isOpen) {
      this.menuTarget.classList.remove('hidden')
    } else {
      this.menuTarget.classList.add('hidden')
    }
  }

  clickOutside(event) {
    if (this.isOpen && !this.element.contains(event.target)) {
      this.isOpen = false
      this.menuTarget.classList.add('hidden')
    }
  }
}
