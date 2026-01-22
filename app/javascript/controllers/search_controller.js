import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "spinner"]
  static values = {
    url: String,
    debounce: { type: Number, default: 300 }
  }

  connect() {
    this.timeout = null
  }

  // Empêcher la soumission du formulaire (recherche live uniquement)
  preventSubmit(event) {
    event.preventDefault()
  }

  search() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      this.performSearch()
    }, this.debounceValue)
  }

  // Recherche immédiate (pour les selects)
  searchNow() {
    clearTimeout(this.timeout)
    this.performSearch()
  }

  performSearch() {
    const url = new URL(this.urlValue, window.location.origin)

    // Collecter tous les inputs du formulaire
    const form = this.element.querySelector('form') || this.element.closest('form')
    if (form) {
      const formData = new FormData(form)
      formData.forEach((value, key) => {
        if (value) {
          url.searchParams.set(key, value)
        }
      })
    } else if (this.hasInputTarget) {
      url.searchParams.set('search', this.inputTarget.value)
    }

    // Conserver les paramètres actuels non présents dans le formulaire
    const currentParams = new URLSearchParams(window.location.search)
    currentParams.forEach((value, key) => {
      if (!url.searchParams.has(key)) {
        url.searchParams.set(key, value)
      }
    })

    this.showLoading()

    fetch(url, {
      headers: {
        'Accept': 'text/vnd.turbo-stream.html',
        'X-Requested-With': 'XMLHttpRequest'
      }
    })
      .then(response => {
        if (!response.ok) throw new Error('Network response was not ok')
        return response.text()
      })
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
      .catch(error => {
        console.error('Search error:', error)
      })
      .finally(() => {
        this.hideLoading()
      })
  }

  showLoading() {
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.remove('hidden')
    }
    if (this.hasInputTarget) {
      this.inputTarget.classList.add('opacity-60')
    }
  }

  hideLoading() {
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.add('hidden')
    }
    if (this.hasInputTarget) {
      this.inputTarget.classList.remove('opacity-60')
    }
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
