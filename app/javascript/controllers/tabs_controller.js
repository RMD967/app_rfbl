import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "button"]

  shiftTab(event) {
    if (event) {
      event.preventDefault()
    }
    const clickedButton = event.currentTarget
    const tabName = clickedButton.dataset.tabName || clickedButton.id

    // Update tab buttons
    const buttons = this.hasButtonTarget
      ? this.buttonTargets
      : this.element.querySelectorAll("[data-action*='shiftTab']")

    buttons.forEach((btn) => {
      if (btn === clickedButton) {
        btn.classList.add("active")
        btn.classList.add("btn-primary")
        btn.classList.remove("btn-outline-primary")
      } else {
        btn.classList.remove("active")
        btn.classList.remove("btn-primary")
        btn.classList.add("btn-outline-primary")
      }
    })

    // Update tab panes
    const tabs = this.hasTabTarget
      ? this.tabTargets
      : this.element.querySelectorAll("[data-tabs-target='tab']")

    tabs.forEach((tab) => {
      const match = tab.id === `${tabName}-tab` || tab.dataset.tabContent === tabName
      if (match) {
        tab.classList.remove("d-none")
      } else {
        tab.classList.add("d-none")
      }
    })
  }
}
