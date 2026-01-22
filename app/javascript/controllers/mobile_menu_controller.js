import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "openIcon", "closeIcon"]

  connect() {
    this.isOpen = false
  }

  toggle() {
    this.isOpen = !this.isOpen

    if (this.hasMenuTarget) {
      this.menuTarget.classList.toggle("hidden", !this.isOpen)
    }

    if (this.hasOpenIconTarget && this.hasCloseIconTarget) {
      this.openIconTarget.classList.toggle("hidden", this.isOpen)
      this.closeIconTarget.classList.toggle("hidden", !this.isOpen)
    }
  }

  close() {
    this.isOpen = false

    if (this.hasMenuTarget) {
      this.menuTarget.classList.add("hidden")
    }

    if (this.hasOpenIconTarget && this.hasCloseIconTarget) {
      this.openIconTarget.classList.remove("hidden")
      this.closeIconTarget.classList.add("hidden")
    }
  }
}
