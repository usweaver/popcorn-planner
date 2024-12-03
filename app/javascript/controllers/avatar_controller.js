import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="avatar"
export default class extends Controller {
  static targets = ["menu"];

  connect() {}

  toggle() {
    if (this.menuTarget.classList.contains("opacity-0")) {
      this.menuTarget.classList.remove("opacity-0");
      this.menuTarget.classList.add("opacity-100");
    } else {
      this.menuTarget.classList.remove("opacity-100");
      this.menuTarget.classList.add("opacity-0");
    }
  }
}
