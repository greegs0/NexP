import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay", "floatingToggle"]

  connect() {
    // Load sidebar state from localStorage
    const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true'
    if (isCollapsed && window.innerWidth >= 768) {
      this.sidebarTarget.classList.add('collapsed')
      this.showFloatingToggle()
    }

    // On mobile, sidebar is hidden by default
    if (window.innerWidth < 768) {
      this.sidebarTarget.classList.add('collapsed')
      this.showFloatingToggle()
    }

    // Update floating toggle on resize with throttling (performance optimization)
    this.resizeHandler = this.throttle(() => this.updateFloatingToggle(), 150)
    window.addEventListener('resize', this.resizeHandler)
  }

  disconnect() {
    // Cleanup event listener on controller destroy
    if (this.resizeHandler) {
      window.removeEventListener('resize', this.resizeHandler)
    }
  }

  // Throttle function to limit resize event calls (performance optimization)
  throttle(func, delay) {
    let lastCall = 0
    return (...args) => {
      const now = Date.now()
      if (now - lastCall >= delay) {
        lastCall = now
        func.apply(this, args)
      }
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

    // Update floating toggle visibility
    this.updateFloatingToggle()
  }

  close() {
    this.sidebarTarget.classList.add('collapsed')
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.add('hidden')
    }
    this.showFloatingToggle()
  }

  updateFloatingToggle() {
    const isCollapsed = this.sidebarTarget.classList.contains('collapsed')
    if (isCollapsed) {
      this.showFloatingToggle()
    } else {
      this.hideFloatingToggle()
    }
  }

  showFloatingToggle() {
    if (this.hasFloatingToggleTarget) {
      this.floatingToggleTarget.classList.remove('hidden')
    }
  }

  hideFloatingToggle() {
    if (this.hasFloatingToggleTarget) {
      this.floatingToggleTarget.classList.add('hidden')
    }
  }
}
