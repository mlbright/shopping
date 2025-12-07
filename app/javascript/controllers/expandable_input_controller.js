import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "input", "actions"]

  expand() {
    this.actionsTarget.classList.remove("hidden")
    this.actionsTarget.classList.add("flex")
  }

  collapse() {
    this.actionsTarget.classList.remove("flex")
    this.actionsTarget.classList.add("hidden")
    this.inputTarget.value = ""
    this.inputTarget.blur()
  }

  maybeCollapse(event) {
    // Only collapse if clicking outside and input is empty
    setTimeout(() => {
      if (this.inputTarget.value.trim() === "") {
        this.collapse()
      }
    }, 200)
  }

  addDeferred(event) {
    event.preventDefault()
    // Add a hidden field for state
    const form = this.element
    const stateInput = document.createElement("input")
    stateInput.type = "hidden"
    stateInput.name = "shopping_item[state]"
    stateInput.value = "deferred"
    form.appendChild(stateInput)
    form.requestSubmit()
    form.removeChild(stateInput)
  }
}
