import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-gallery"
export default class extends Controller {
  static targets = ["image", "modal", "modalImage"];

  open(event) {
    // Get the clicked image's src attribute
    const src = event.currentTarget.getAttribute("src");

    // Set the modal image's src attribute to the clicked image's src
    this.modalImageTarget.setAttribute("src", src);

    // Show the modal
    this.modalTarget.classList.add("active");
  }

  close() {
    // Hide the modal
    this.modalTarget.classList.remove("active");
  }
}
