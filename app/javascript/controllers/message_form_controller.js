import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="message-form"
export default class extends Controller {
  static targets = ["textarea", "form"]

  connect() {
    // Focus automatique sur le textarea
    if (this.hasTextareaTarget) {
      this.textareaTarget.focus()
      // S'assurer que le textarea est vide à la connexion (après remplacement Turbo)
      // Le navigateur peut parfois remplir avec l'autocomplete
      this.textareaTarget.value = ''
    }

    // Scroll vers le bas quand le formulaire est reconnecté (après Turbo Stream)
    this.scrollToBottom()

    // Écouter les événements Turbo sur le document pour ce formulaire
    this.boundHandleSubmitEnd = this.handleSubmitEnd.bind(this)
    document.addEventListener('turbo:submit-end', this.boundHandleSubmitEnd)
  }

  disconnect() {
    document.removeEventListener('turbo:submit-end', this.boundHandleSubmitEnd)
  }

  handleSubmitEnd(event) {
    // Vérifie que c'est notre formulaire qui a été soumis
    if (this.hasFormTarget && event.target === this.formTarget && event.detail.success) {
      this.textareaTarget.value = ''
      this.textareaTarget.focus()
      setTimeout(() => this.scrollToBottom(), 100)
    }
  }

  handleKeydown(event) {
    // Si Entrée est pressée SANS Shift
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault() // Empêche le retour à la ligne par défaut
      this.submitForm()
    }
    // Si Shift + Entrée, on laisse le comportement par défaut (retour à la ligne)
  }

  // Appelé quand le bouton Envoyer est cliqué
  submit(event) {
    const content = this.textareaTarget.value.trim()
    if (content.length === 0) {
      event.preventDefault()
      return
    }
    // Laisser Turbo gérer la soumission et le clear
  }

  submitForm() {
    // Vérifie que le textarea n'est pas vide
    const content = this.textareaTarget.value.trim()
    if (content.length > 0 && this.hasFormTarget) {
      // Soumet le formulaire via Turbo
      this.formTarget.requestSubmit()
    }
  }

  scrollToBottom() {
    const messagesContainer = document.getElementById('messages_container')
    if (messagesContainer) {
      messagesContainer.scrollTop = messagesContainer.scrollHeight
    }
  }
}
