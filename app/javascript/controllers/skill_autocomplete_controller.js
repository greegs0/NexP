import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropdown", "spinner"]
  static values = {
    url: { type: String, default: "/skills/autocomplete" },
    searchUrl: String,
    debounce: { type: Number, default: 150 },
    searchDebounce: { type: Number, default: 400 }
  }

  connect() {
    this.timeout = null
    this.searchTimeout = null
    this.selectedIndex = -1
    this.results = []

    // Fermer le dropdown quand on clique ailleurs
    this.clickOutsideHandler = (e) => {
      if (!this.element.contains(e.target)) {
        this.hideDropdown()
      }
    }
    document.addEventListener('click', this.clickOutsideHandler)
  }

  disconnect() {
    clearTimeout(this.timeout)
    clearTimeout(this.searchTimeout)
    document.removeEventListener('click', this.clickOutsideHandler)
  }

  search() {
    clearTimeout(this.timeout)
    clearTimeout(this.searchTimeout)
    const query = this.inputTarget.value.trim()

    if (query.length < 1) {
      this.hideDropdown()
      // Réinitialiser les résultats de recherche si query vide
      this.clearSearchResults()
      return
    }

    // Autocomplete dropdown (rapide)
    this.timeout = setTimeout(() => {
      this.fetchResults(query)
    }, this.debounceValue)

    // Mise à jour des résultats de recherche (un peu plus lent)
    this.searchTimeout = setTimeout(() => {
      this.performSearch()
    }, this.searchDebounceValue)
  }

  async fetchResults(query) {
    this.showLoading()

    try {
      const url = new URL(this.urlValue, window.location.origin)
      url.searchParams.set('q', query)

      const response = await fetch(url, {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })

      if (!response.ok) throw new Error('Network error')

      this.results = await response.json()
      this.renderDropdown()
    } catch (error) {
      console.error('Autocomplete error:', error)
      this.hideDropdown()
    } finally {
      this.hideLoading()
    }
  }

  renderDropdown() {
    if (this.results.length === 0) {
      this.dropdownTarget.innerHTML = `
        <div class="px-4 py-3 text-sm text-muted-foreground">
          Aucun résultat trouvé
        </div>
      `
      this.showDropdown()
      return
    }

    const html = this.results.map((skill, index) => `
      <button type="button"
              class="autocomplete-item w-full text-left px-4 py-2.5 hover:bg-primary/10 focus:bg-primary/10 focus:outline-none transition-colors flex items-center gap-3 ${index === this.selectedIndex ? 'bg-primary/10' : ''}"
              data-action="click->skill-autocomplete#selectSkill"
              data-skill-id="${skill.id}"
              data-skill-name="${skill.name}">
        <span class="flex-1 font-medium text-foreground">${this.highlightMatch(skill.name)}</span>
        <span class="text-xs px-2 py-0.5 rounded bg-secondary text-muted-foreground">${skill.category}</span>
      </button>
    `).join('')

    this.dropdownTarget.innerHTML = html
    this.showDropdown()
  }

  highlightMatch(text) {
    const query = this.inputTarget.value.trim()
    if (!query) return text

    const regex = new RegExp(`(${query})`, 'gi')
    return text.replace(regex, '<span class="text-primary font-semibold">$1</span>')
  }

  selectSkill(event) {
    const skillId = event.currentTarget.dataset.skillId
    const skillName = event.currentTarget.dataset.skillName

    // Ajouter la skill via POST
    this.addSkill(skillId, skillName)
  }

  async addSkill(skillId, skillName) {
    try {
      const response = await fetch('/user_skills', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'text/vnd.turbo-stream.html, text/html',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: `skill_id=${skillId}`
      })

      if (response.ok) {
        // Vider l'input et fermer le dropdown
        this.inputTarget.value = ''
        this.hideDropdown()

        // Recharger la page pour voir les changements
        // (ou utiliser Turbo Stream si configuré)
        const html = await response.text()
        if (html.includes('turbo-stream')) {
          Turbo.renderStreamMessage(html)
        } else {
          window.location.reload()
        }
      }
    } catch (error) {
      console.error('Error adding skill:', error)
    }
  }

  // Navigation clavier
  keydown(event) {
    if (!this.isDropdownVisible()) return

    switch(event.key) {
      case 'ArrowDown':
        event.preventDefault()
        this.moveSelection(1)
        break
      case 'ArrowUp':
        event.preventDefault()
        this.moveSelection(-1)
        break
      case 'Enter':
        event.preventDefault()
        if (this.selectedIndex >= 0 && this.results[this.selectedIndex]) {
          const skill = this.results[this.selectedIndex]
          this.addSkill(skill.id, skill.name)
        } else {
          // Faire la recherche normale
          this.performSearch()
        }
        break
      case 'Escape':
        this.hideDropdown()
        this.inputTarget.blur()
        break
    }
  }

  moveSelection(direction) {
    const newIndex = this.selectedIndex + direction
    if (newIndex >= -1 && newIndex < this.results.length) {
      this.selectedIndex = newIndex
      this.updateSelectionUI()
    }
  }

  updateSelectionUI() {
    const items = this.dropdownTarget.querySelectorAll('.autocomplete-item')
    items.forEach((item, index) => {
      if (index === this.selectedIndex) {
        item.classList.add('bg-primary/10')
      } else {
        item.classList.remove('bg-primary/10')
      }
    })
  }

  // Recherche Turbo (quand on veut filtrer la liste complète)
  performSearch() {
    if (!this.hasSearchUrlValue) return

    const query = this.inputTarget.value.trim()
    const url = new URL(this.searchUrlValue, window.location.origin)

    if (query) {
      url.searchParams.set('search', query)
    }

    fetch(url, {
      headers: {
        'Accept': 'text/vnd.turbo-stream.html',
        'X-Requested-With': 'XMLHttpRequest'
      }
    })
      .then(response => response.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
  }

  // Réinitialiser les résultats de recherche
  clearSearchResults() {
    if (!this.hasSearchUrlValue) return

    const url = new URL(this.searchUrlValue, window.location.origin)
    // Pas de paramètre search = affiche juste les suggestions

    fetch(url, {
      headers: {
        'Accept': 'text/vnd.turbo-stream.html',
        'X-Requested-With': 'XMLHttpRequest'
      }
    })
      .then(response => response.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
  }

  showDropdown() {
    this.dropdownTarget.classList.remove('hidden')
    this.selectedIndex = -1
  }

  hideDropdown() {
    this.dropdownTarget.classList.add('hidden')
    this.selectedIndex = -1
    this.results = []
  }

  isDropdownVisible() {
    return !this.dropdownTarget.classList.contains('hidden')
  }

  showLoading() {
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.remove('hidden')
    }
  }

  hideLoading() {
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.add('hidden')
    }
  }

  // Quand l'input perd le focus
  blur() {
    // Délai pour permettre le clic sur un item
    setTimeout(() => {
      this.hideDropdown()
    }, 200)
  }
}
