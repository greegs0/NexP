import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    animation: { type: String, default: "fade-up" },
    delay: { type: Number, default: 0 },
    threshold: { type: Number, default: 0.1 }
  }

  connect() {
    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            this.animate()
            this.observer.unobserve(this.element)
          }
        })
      },
      {
        threshold: this.thresholdValue,
        rootMargin: "0px 0px -50px 0px"
      }
    )

    this.observer.observe(this.element)
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  animate() {
    const animationClass = this.getAnimationClass()

    setTimeout(() => {
      this.element.classList.remove("scroll-animate")
      this.element.classList.add(animationClass)
      this.element.style.animationFillMode = "forwards"
    }, this.delayValue)
  }

  getAnimationClass() {
    const animations = {
      "fade-up": "animate-fade-in-up",
      "fade-in": "animate-fade-in",
      "scale-in": "animate-scale-in",
      "slide-left": "animate-slide-in-left",
      "slide-right": "animate-slide-in-right"
    }

    return animations[this.animationValue] || "animate-fade-in-up"
  }
}
