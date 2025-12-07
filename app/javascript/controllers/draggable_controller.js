import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["handle"]
  static values = { url: String }

  connect() {
    this.element.draggable = true
    
    this.element.addEventListener("dragstart", this.dragStart.bind(this))
    this.element.addEventListener("dragover", this.dragOver.bind(this))
    this.element.addEventListener("drop", this.drop.bind(this))
    this.element.addEventListener("dragend", this.dragEnd.bind(this))
  }

  dragStart(event) {
    event.dataTransfer.effectAllowed = "move"
    event.dataTransfer.setData("text/html", this.element.innerHTML)
    this.element.classList.add("opacity-50")
    
    // Store the dragged element's ID
    window.draggedElement = this.element
  }

  dragOver(event) {
    event.preventDefault()
    event.dataTransfer.dropEffect = "move"
    
    const afterElement = this.getDragAfterElement(event.clientY)
    const draggable = window.draggedElement
    
    if (afterElement == null) {
      this.element.parentElement.appendChild(draggable)
    } else {
      this.element.parentElement.insertBefore(draggable, afterElement)
    }
  }

  drop(event) {
    event.preventDefault()
    event.stopPropagation()
  }

  dragEnd(event) {
    this.element.classList.remove("opacity-50")
    this.updatePosition()
  }

  getDragAfterElement(y) {
    const draggableElements = [...this.element.parentElement.querySelectorAll("[data-controller='draggable']:not(.opacity-50)")]
    
    return draggableElements.reduce((closest, child) => {
      const box = child.getBoundingClientRect()
      const offset = y - box.top - box.height / 2
      
      if (offset < 0 && offset > closest.offset) {
        return { offset: offset, element: child }
      } else {
        return closest
      }
    }, { offset: Number.NEGATIVE_INFINITY }).element
  }

  updatePosition() {
    const items = [...this.element.parentElement.querySelectorAll("[data-controller='draggable']")]
    const newPosition = items.indexOf(this.element) + 1
    
    // Send PATCH request to update position (last-write-wins)
    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({ position: newPosition })
    })
  }
}
