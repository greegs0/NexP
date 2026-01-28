import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay"]

  connect() {
    // Mobile: sidebar starts collapsed (hidden)
    if (window.innerWidth < 768) {
      this.sidebarTarget.classList.add('collapsed')
      return
    }

    // Desktop: restore state from localStorage
    const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true'
    if (isCollapsed) {
      this.sidebarTarget.classList.add('collapsed')
    }
  }

  toggle() {
    const isCollapsed = this.sidebarTarget.classList.toggle('collapsed')

    // Desktop: persist state
    if (window.innerWidth >= 768) {
      localStorage.setItem('sidebarCollapsed', isCollapsed)
    }

    // Mobile: manage overlay
    if (window.innerWidth < 768 && this.hasOverlayTarget) {
      this.overlayTarget.classList.toggle('hidden', isCollapsed)
    }
  }

  close() {
    this.sidebarTarget.classList.add('collapsed')
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.add('hidden')
    }
  }
}
