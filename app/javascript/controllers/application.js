import { Application } from "@hotwired/stimulus";
import confetti from "canvas-confetti";

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;
window.confetti = confetti;

export { application };
