import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-to-section"
export default class extends Controller {
  connect() {
    // Do nothing when the controller is connected
  }

  scrollToSection(event) {
    event.preventDefault();
    const targetId = this.element.getAttribute("href").substring(1);
    const targetElement = document.getElementById(targetId);
    if (targetElement) {
      targetElement.scrollIntoView({ behavior: "smooth" });
    }
  }
}
