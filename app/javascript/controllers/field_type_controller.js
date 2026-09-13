import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "options"]

  connect() {
    this.toggle()
  }

  toggle() {
    this.optionsTarget.hidden = this.selectTarget.value !== "choice"
  }
}
