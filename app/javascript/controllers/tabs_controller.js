import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "tab" ]


  shiftTab(event) {
    const tabButton = event.currentTarget
    this.tabTargets.forEach((tab) => {
      if (`${tabButton.id}-tab` === tab.id) {
        tab.classList.remove("d-none")
        tabButton.classList.remove("btn-outline-primary")
        tabButton.classList.add("btn-primary")
      } else {
        tab.classList.add("d-none")
        tabButton.classList.remove("btn-primary")
        tabButton.classList.add("btn-outline-primary")
      }
    })
  }
}
