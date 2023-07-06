import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="event"
export default class extends Controller {
  static targets = ["events"]

  chooseGenre(e) {
    e.preventDefault()
    console.log(e.currentTarget)
    const anchor = this.element.querySelector(`.${e.currentTarget.dataset.genre}`)
    anchor.classList.add("active")
    this.element.querySelectorAll(".icon-link").forEach((genre) => {
      if (genre != anchor) {
        genre.classList.remove("active")
      }
    })

    fetch(`/events?genre=${anchor.dataset.genre}`, {
      headers: { 
        "accept": "text/plain",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      }
    })
      .then(response => response.text())
      .then((data) => {
        this.eventsTarget.outerHTML = data
      })
  }
  
}
