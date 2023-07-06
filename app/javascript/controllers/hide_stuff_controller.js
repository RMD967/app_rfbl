import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hide-stuff"
export default class extends Controller {
  static targets = ["map"]

  connect() {
  }

  toggleMap() {
    this.mapTarget.classList.toggle("d-none")
  }
}
