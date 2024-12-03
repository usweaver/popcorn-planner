import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="next-form"
export default class extends Controller {

  static targets = ["textBar", "percentBar", "recap", "nameInput", "groupInput", "dateInput", "timeInput", "moviesInput"]
  static values = {
    url: String
  }
  connect() {
    console.log("next-from controller is connected");
    this.step = 0
  }

  nextFormName(event) {
    event.preventDefault();

    const currentForm = document.getElementById("event-name")
    const targetForm = document.getElementById("event-group")

    currentForm.classList.add("hidden")
    targetForm.classList.remove("hidden")
    this.percentBarTarget.classList.remove("w-[0%]")
    this.percentBarTarget.classList.add("w-[25%]")
    this.textBarTarget.innerText = "25%"
  }

  nextFormDate(event) {
    event.preventDefault();
    const currentForm = document.getElementById("event-group")
    const targetForm = document.getElementById("event-date")

    currentForm.classList.add("hidden")
    targetForm.classList.remove("hidden")
    this.percentBarTarget.classList.remove("w-[25%]")
    this.percentBarTarget.classList.add("w-[50%]")
    this.textBarTarget.innerText = "50%"
  }

  nextFormMovie(event) {
    event.preventDefault();
    const currentForm = document.getElementById("event-date")
    const targetForm = document.getElementById("event-movie")
    this.date = currentForm.value

    currentForm.classList.add("hidden")
    targetForm.classList.remove("hidden")
    this.percentBarTarget.classList.remove("w-[50%]")
    this.percentBarTarget.classList.add("w-[75%]")
    this.textBarTarget.innerText = "75%"
  }

  nextFormCreate(event) {
    event.preventDefault();
    const currentForm = document.getElementById("event-movie")
    const targetForm = document.getElementById("event-create")

    currentForm.classList.add("hidden")
    targetForm.classList.remove("hidden")
    this.percentBarTarget.classList.remove("w-[75%]")
    this.percentBarTarget.classList.add("w-[100%]")
    this.textBarTarget.innerText = "100%"
    this.getValueInput()
  }

  getValueInput() {
    const nameInput = this.nameInputTarget
    const groupInput = this.groupInputTarget
    const dateInput = this.dateInputTarget
    const timeInput = this.dateInputTarget
    const moviesInput = this.moviesInputTarget

    const url = `/events/create_recap?name=${nameInput.value}&group=${groupInput.value}&date=${dateInput.value}&time=${timeInput.value}&movies_infos=${moviesInput.value}`

    fetch(url)
      .then(response => response.json())
      .then(data => {
        const recapHtml = data.recap_html
        this.recapTarget.insertAdjacentHTML('beforeend', recapHtml)
      })
  }
}
