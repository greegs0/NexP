import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    duration: { type: Number, default: 4000 },
    type: { type: String, default: 'notice' }
  }

  connect() {
    // Don't auto-dismiss errors
    if (this.typeValue !== 'error') {
      this.timeout = setTimeout(() => {
        this.dismiss()
      }, this.durationValue)
    }

    // Pause timer on hover
    this.element.addEventListener('mouseenter', () => this.pause())
    this.element.addEventListener('mouseleave', () => this.resume())
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  pause() {
    if (this.timeout) {
      clearTimeout(this.timeout)
      this.timeout = null
    }
  }

  resume() {
    if (this.typeValue !== 'error' && !this.timeout) {
      this.timeout = setTimeout(() => {
        this.dismiss()
      }, 2000)
    }
  }

  dismiss() {
    this.element.style.opacity = '0'
    this.element.style.transform = 'translateY(-10px)'

    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
