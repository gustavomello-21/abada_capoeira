import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, Date.now())
    this.containerTarget.insertAdjacentHTML("beforeend", content)
  }

  remove(event) {
    event.preventDefault()
    const row = event.target.closest("[data-nested-fields-row]")

    if (row.dataset.persisted === "true") {
      row.querySelector("input[name*='[_destroy]']").value = "1"
      row.hidden = true
    } else {
      row.remove()
    }
  }
}
