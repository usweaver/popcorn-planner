import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="body"
export default class extends Controller {
  connect() {
    const isPWA =
      window.matchMedia("(display-mode: standalone)").matches ||
      window.navigator.standalone === true;

    if (isPWA) {
      // Si en mode PWA, ajouter une classe à l'élément cible
      const pwa_bar = document.querySelector("#pwa-bar");
      const main = document.querySelector("main");
      pwa_bar.classList.remove("hidden");
      main.classList.remove("pb-16");
      main.classList.add("pb-24");
    }
  }
}
