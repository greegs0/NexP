import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["replyForm"]

  toggleReplyForm(event) {
    event.preventDefault()
    this.replyFormTarget.classList.toggle("hidden")
  }
}
