import { Controller } from "@hotwired/stimulus";
import toastr from "toastr";

// Connects to data-controller="toastr"
export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.classList.remove("-translate-x-256");
    }, 300);
    setTimeout(() => {
      this.element.classList.add("-translate-x-256");
    }, 5000);
  }
}
