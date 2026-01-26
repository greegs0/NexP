import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="message-form"
export default class extends Controller {
  static targets = ["textarea", "form"]

  connect() {
    console.log("Message form controller connected")
    // Focus automatique sur le textarea
    this.textareaTarget.focus()

    // Scroll vers le bas quand le formulaire est reconnecté (après Turbo Stream)
    this.scrollToBottom()
  }

  handleKeydown(event) {
    // Si Entrée est pressée SANS Shift
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault() // Empêche le retour à la ligne par défaut
      this.submitForm()
    }
    // Si Shift + Entrée, on laisse le comportement par défaut (retour à la ligne)
  }

  submitForm() {
    // Vérifie que le textarea n'est pas vide
    const content = this.textareaTarget.value.trim()
    if (content.length > 0) {
      // Soumet le formulaire (les données sont capturées à ce moment)
      this.formTarget.requestSubmit()

      // Vide immédiatement le textarea APRÈS la capture des données
      // pour une UX instantanée
      this.textareaTarget.value = ''
      this.textareaTarget.focus()

      // Scroll vers le bas après l'envoi
      setTimeout(() => this.scrollToBottom(), 200)
    }
  }

  scrollToBottom() {
    const messagesContainer = document.getElementById('messages_container')
    if (messagesContainer) {
      messagesContainer.scrollTop = messagesContainer.scrollHeight
    }
  }
}
