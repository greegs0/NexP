import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "name", "description"]
  static values = { open: Boolean }

  connect() {
    this.boundKeydown = this.keydown.bind(this)
  }

  open(event) {
    event.preventDefault()
    event.stopPropagation()

    const name = event.currentTarget.dataset.badgeName
    const description = event.currentTarget.dataset.badgeDescription

    if (this.hasNameTarget) {
      this.nameTarget.textContent = name
    }
    if (this.hasDescriptionTarget) {
      this.descriptionTarget.textContent = description
    }
    if (this.hasModalTarget) {
      this.modalTarget.classList.remove('hidden')
      document.addEventListener('keydown', this.boundKeydown)
      document.body.style.overflow = 'hidden'
    }
  }

  close() {
    this.modalTarget.classList.add('hidden')
    document.removeEventListener('keydown', this.boundKeydown)
    document.body.style.overflow = ''
  }

  clickOutside(event) {
    if (event.target === this.modalTarget) {
      this.close()
    }
  }

  keydown(event) {
    if (event.key === 'Escape') {
      this.close()
    }
  }
}
