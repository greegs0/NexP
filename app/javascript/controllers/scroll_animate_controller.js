import { Controller } from "@hotwired/stimulus"

// Shared IntersectionObserver pool for better performance
// Reuses observers with same configuration instead of creating one per element
const observerPool = new Map()

function getSharedObserver(threshold, callback) {
  const key = `threshold-${threshold}`

  if (!observerPool.has(key)) {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            const element = entry.target
            const controller = element._scrollAnimateController
            if (controller) {
              controller.animate()
              observer.unobserve(element)
            }
          }
        })
      },
      {
        threshold: threshold,
        rootMargin: "0px 0px -50px 0px"
      }
    )
    observerPool.set(key, observer)
  }

  return observerPool.get(key)
}

export default class extends Controller {
  static values = {
    animation: { type: String, default: "fade-up" },
    delay: { type: Number, default: 0 },
    threshold: { type: Number, default: 0.1 }
  }

  connect() {
    // Store controller reference on element for observer callback
    this.element._scrollAnimateController = this

    // Get shared observer from pool instead of creating new one
    this.observer = getSharedObserver(this.thresholdValue)
    this.observer.observe(this.element)
  }

  disconnect() {
    if (this.observer) {
      this.observer.unobserve(this.element)
    }
    // Cleanup controller reference
    delete this.element._scrollAnimateController
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
