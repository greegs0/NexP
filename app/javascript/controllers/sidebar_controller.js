import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay"]

  connect() {
    // Load sidebar state from localStorage
    const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true'
    if (isCollapsed && window.innerWidth >= 768) {
      this.sidebarTarget.classList.add('collapsed')
    }

    // On mobile, sidebar is hidden by default
    if (window.innerWidth < 768) {
      this.sidebarTarget.classList.add('collapsed')
    }
  }

  toggle() {
    this.sidebarTarget.classList.toggle('collapsed')
    const isCollapsed = this.sidebarTarget.classList.contains('collapsed')

    if (window.innerWidth >= 768) {
      localStorage.setItem('sidebarCollapsed', isCollapsed)
    }

    // Show/hide overlay on mobile
    if (window.innerWidth < 768 && this.hasOverlayTarget) {
      if (isCollapsed) {
        this.overlayTarget.classList.add('hidden')
      } else {
        this.overlayTarget.classList.remove('hidden')
      }
    }
  }

  close() {
    this.sidebarTarget.classList.add('collapsed')
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.add('hidden')
    }
  }
}
