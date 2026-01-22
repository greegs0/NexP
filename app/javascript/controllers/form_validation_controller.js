import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "counter", "hint"]
  static values = {
    maxLength: { type: Number, default: 0 },
    minLength: { type: Number, default: 0 },
    required: { type: Boolean, default: false }
  }

  connect() {
    this.updateCounter()
  }

  validate() {
    const value = this.inputTarget.value
    const length = value.length
    let isValid = true
    let message = ""

    // Check required
    if (this.requiredValue && length === 0) {
      isValid = false
      message = "Ce champ est requis"
    }
    // Check min length
    else if (this.minLengthValue > 0 && length < this.minLengthValue && length > 0) {
      isValid = false
      message = `Minimum ${this.minLengthValue} caractères`
    }
    // Check max length
    else if (this.maxLengthValue > 0 && length > this.maxLengthValue) {
      isValid = false
      message = `Maximum ${this.maxLengthValue} caractères`
    }

    this.updateValidationState(isValid, message)
    this.updateCounter()
  }

  updateCounter() {
    if (!this.hasCounterTarget || !this.maxLengthValue) return

    const length = this.inputTarget.value.length
    const remaining = this.maxLengthValue - length

    this.counterTarget.textContent = `${length}/${this.maxLengthValue}`

    if (remaining < 0) {
      this.counterTarget.classList.add('text-destructive')
      this.counterTarget.classList.remove('text-muted-foreground', 'text-warning')
    } else if (remaining < 50) {
      this.counterTarget.classList.add('text-warning')
      this.counterTarget.classList.remove('text-muted-foreground', 'text-destructive')
    } else {
      this.counterTarget.classList.add('text-muted-foreground')
      this.counterTarget.classList.remove('text-warning', 'text-destructive')
    }
  }

  updateValidationState(isValid, message) {
    if (isValid) {
      this.inputTarget.classList.remove('border-destructive', 'focus:border-destructive')
      if (this.hasHintTarget) {
        this.hintTarget.textContent = ""
        this.hintTarget.classList.add('hidden')
      }
    } else {
      this.inputTarget.classList.add('border-destructive', 'focus:border-destructive')
      if (this.hasHintTarget) {
        this.hintTarget.textContent = message
        this.hintTarget.classList.remove('hidden')
      }
    }
  }
}
