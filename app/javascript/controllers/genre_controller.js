import { Controller } from "@hotwired/stimulus"


// Connects to data-controller="genre"
export default class extends Controller {

  static targets = [ "genreButton" ]

  toggleColor(event) {
    this.#resetAll()
    event.currentTarget.classList.toggle("text-white")
  }

  #resetAll() {
    this.genreButtonTargets.forEach((element) => {
      element.classList.remove("text-white")
    })
  }
}
