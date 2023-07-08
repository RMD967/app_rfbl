import { Controller } from "@hotwired/stimulus"

function shiftTab(event) {
  const tabButton = event.currentTarget;
  const tabTargets = document.querySelectorAll("[data-tabs-target='tab']");

  tabTargets.forEach((tab) => {
    if (`${tabButton.id}-tab` === tab.id) {
      tab.classList.remove("d-none");
      tabButton.classList.remove("btn-outline-primary");
      tabButton.classList.add("btn-primary");
    } else {
      tab.classList.add("d-none");
      tabButton.classList.remove("btn-primary");
      tabButton.classList.add("btn-outline-primary");
    }
  });
}

const tabButtons = document.querySelectorAll("[data-action='click->tabs#shiftTab']");
tabButtons.forEach((button) => {
  button.addEventListener("click", shiftTab);
});
