import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="radio-button"
export default class extends Controller {
  static targets =["togglableElement", "input"]
  connect() {
  }

  select(event) {

    this.togglableElementTargets.forEach((element) => {
      element.dataset.selected = false
      // element.classList.remove("outline", "outline-yellow-400", "outline-offset-2")
    })

    const card = event.currentTarget

    // card.classList.add("outline","outline-yellow-400","outline-offset-2")
    card.dataset.selected = true

    const groupId = card.dataset.groupId
    this.inputTarget.value = groupId
  }
}
