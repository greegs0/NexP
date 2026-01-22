import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "sunIcon", "moonIcon", "label"]

  connect() {
    // Load theme from localStorage or default to dark
    const savedTheme = localStorage.getItem('theme') || 'dark'
    this.setTheme(savedTheme, false)
  }

  toggle(event) {
    // For checkbox inputs, determine theme based on checked state
    if (event.target && event.target.type === 'checkbox') {
      const newTheme = event.target.checked ? 'light' : 'dark'
      this.setTheme(newTheme, true)
    } else {
      // For button clicks, toggle between themes
      const currentTheme = document.documentElement.getAttribute('data-theme') || 'dark'
      const newTheme = currentTheme === 'dark' ? 'light' : 'dark'
      this.setTheme(newTheme, true)
    }
  }

  setTheme(theme, updateCheckbox = true) {
    document.documentElement.setAttribute('data-theme', theme)
    document.documentElement.className = theme
    localStorage.setItem('theme', theme)

    // Update icons visibility
    // Sun icon shown in dark mode (click to switch to light)
    // Moon icon shown in light mode (click to switch to dark)
    if (this.hasSunIconTarget && this.hasMoonIconTarget) {
      if (theme === 'dark') {
        this.sunIconTarget.classList.remove('hidden')
        this.moonIconTarget.classList.add('hidden')
      } else {
        this.sunIconTarget.classList.add('hidden')
        this.moonIconTarget.classList.remove('hidden')
      }
    }

    // Update label if present
    if (this.hasLabelTarget) {
      this.labelTarget.textContent = theme === 'dark' ? 'Sombre' : 'Clair'
    }

    // Update all checkboxes on the page
    this.checkboxTargets.forEach(checkbox => {
      checkbox.checked = (theme === 'light')
    })
  }
}
