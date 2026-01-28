import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "content"]
  static values = {
    debounce: { type: Number, default: 300 }
  }

  connect() {
    this.timeout = null
    this.isOpen = false

    // Fermer en cliquant ailleurs
    this.boundClickOutside = this.clickOutside.bind(this)
    document.addEventListener('click', this.boundClickOutside)
  }

  disconnect() {
    clearTimeout(this.timeout)
    document.removeEventListener('click', this.boundClickOutside)
  }

  search() {
    const query = this.inputTarget.value.trim()

    if (query.length < 2) {
      this.hideResults()
      return
    }

    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.performSearch(query)
    }, this.debounceValue)
  }

  handleKeydown(event) {
    if (event.key === 'Escape') {
      this.hideResults()
      this.inputTarget.blur()
    } else if (event.key === 'Enter') {
      event.preventDefault()
      const query = this.inputTarget.value.trim()
      if (query.length >= 2) {
        // Rediriger vers la page de recherche complète
        window.location.href = `/users?search=${encodeURIComponent(query)}`
      }
    }
  }

  showResults() {
    if (this.inputTarget.value.trim().length >= 2) {
      this.resultsTarget.classList.remove('hidden')
      this.isOpen = true
    }
  }

  hideResults() {
    // Délai pour permettre les clics sur les résultats
    setTimeout(() => {
      this.resultsTarget.classList.add('hidden')
      this.isOpen = false
    }, 200)
  }

  clickOutside(event) {
    if (this.isOpen && !this.element.contains(event.target)) {
      this.resultsTarget.classList.add('hidden')
      this.isOpen = false
    }
  }

  async performSearch(query) {
    this.contentTarget.innerHTML = `
      <div class="p-4 text-center text-sm text-muted-foreground">
        <svg class="w-5 h-5 animate-spin mx-auto" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
      </div>
    `
    this.resultsTarget.classList.remove('hidden')
    this.isOpen = true

    try {
      // Recherche parallèle sur users et projects
      const [usersRes, projectsRes] = await Promise.all([
        fetch(`/api/v1/users?search=${encodeURIComponent(query)}&limit=3`, {
          headers: { 'Accept': 'application/json' }
        }),
        fetch(`/api/v1/projects?search=${encodeURIComponent(query)}&limit=3`, {
          headers: { 'Accept': 'application/json' }
        })
      ])

      const users = usersRes.ok ? await usersRes.json() : []
      const projects = projectsRes.ok ? await projectsRes.json() : []

      this.renderResults(query, users, projects)
    } catch (error) {
      console.error('Search error:', error)
      this.contentTarget.innerHTML = `
        <div class="p-4 text-center text-sm text-muted-foreground">
          Erreur de recherche
        </div>
      `
    }
  }

  renderResults(query, users, projects) {
    const usersData = users.data || users || []
    const projectsData = projects.data || projects || []

    if (usersData.length === 0 && projectsData.length === 0) {
      this.contentTarget.innerHTML = `
        <div class="p-4 text-center text-sm text-muted-foreground">
          Aucun résultat pour "${this.escapeHtml(query)}"
        </div>
      `
      return
    }

    let html = ''

    // Section Développeurs
    if (usersData.length > 0) {
      html += `
        <div class="p-2 border-b border-border">
          <p class="text-xs font-semibold text-muted-foreground px-2 mb-1">DÉVELOPPEURS</p>
          ${usersData.map(user => `
            <a href="/users/${user.id}" class="flex items-center gap-3 p-2 hover:bg-secondary/50 rounded-md transition-colors">
              <div class="w-8 h-8 bg-primary text-primary-foreground rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0">
                ${(user.display_name || user.username || '?')[0].toUpperCase()}
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-sm font-medium text-foreground truncate">${this.escapeHtml(user.display_name || user.username)}</p>
                <p class="text-xs text-muted-foreground">Niveau ${user.level || 1}</p>
              </div>
            </a>
          `).join('')}
        </div>
      `
    }

    // Section Projets
    if (projectsData.length > 0) {
      html += `
        <div class="p-2">
          <p class="text-xs font-semibold text-muted-foreground px-2 mb-1">PROJETS</p>
          ${projectsData.map(project => `
            <a href="/projects/${project.id}" class="flex items-center gap-3 p-2 hover:bg-secondary/50 rounded-md transition-colors">
              <div class="w-8 h-8 bg-secondary rounded-lg flex items-center justify-center flex-shrink-0">
                <svg class="w-4 h-4 text-muted-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path>
                </svg>
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-sm font-medium text-foreground truncate">${this.escapeHtml(project.title)}</p>
                <p class="text-xs text-muted-foreground">${project.current_members_count || 0}/${project.max_members || 5} membres</p>
              </div>
            </a>
          `).join('')}
        </div>
      `
    }

    // Lien voir plus
    html += `
      <a href="/users?search=${encodeURIComponent(query)}" class="block p-3 text-center text-sm text-primary hover:bg-secondary/30 border-t border-border font-medium">
        Voir tous les résultats →
      </a>
    `

    this.contentTarget.innerHTML = html
  }

  escapeHtml(text) {
    if (!text) return ''
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
  }
}
