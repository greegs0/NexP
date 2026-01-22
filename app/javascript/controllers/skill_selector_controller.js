import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "counter", "searchInput", "skillItem"]
  static values = {
    max: { type: Number, default: 20 }
  }

  connect() {
    this.updateCounter()
  }

  toggle(event) {
    this.updateCounter()
  }

  updateCounter() {
    if (!this.hasCounterTarget) return

    const checked = this.checkboxTargets.filter(cb => cb.checked).length
    this.counterTarget.textContent = `${checked} compétence${checked > 1 ? 's' : ''} sélectionnée${checked > 1 ? 's' : ''}`

    if (checked >= this.maxValue) {
      this.counterTarget.classList.add('text-warning')
    } else {
      this.counterTarget.classList.remove('text-warning')
    }
  }

  filter() {
    if (!this.hasSearchInputTarget) return

    const query = this.searchInputTarget.value.toLowerCase().trim()

    this.skillItemTargets.forEach(item => {
      const name = item.dataset.skillName.toLowerCase()
      if (query === '' || name.includes(query)) {
        item.classList.remove('hidden')
      } else {
        item.classList.add('hidden')
      }
    })
  }

  selectAll(event) {
    event.preventDefault()
    const category = event.currentTarget.dataset.category

    this.checkboxTargets.forEach(cb => {
      if (!category || cb.dataset.category === category) {
        cb.checked = true
      }
    })
    this.updateCounter()
  }

  deselectAll(event) {
    event.preventDefault()
    this.checkboxTargets.forEach(cb => cb.checked = false)
    this.updateCounter()
  }
}
