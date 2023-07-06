import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="instruments"
export default class extends Controller {
  static targets = ["container", "addButton", "template", "label", "field", "limitMessage"]
  static values = { limit: Number }

  addInstrument() {
    if (this.containerTarget.childElementCount < this.limitValue) {
      const lastInput = this.containerTarget.querySelector("input:last-of-type");
      if (lastInput) lastInput.value = "";
      // Clone the template and remove the style attribute
      const newField = this.templateTarget.cloneNode(true);
      newField.removeAttribute("style");
      // Update the label text
      const label = newField.querySelector("[data-target='instruments--label']");
      if (label) {
        const instrumentCount = this.containerTarget.childElementCount;
        label.textContent = `Artist instrument ${instrumentCount}`;
      }
      // Show the remove button for additional instruments
      const removeButton = newField.querySelector("[data-action='instruments#removeInstrument']");
      if (removeButton) {
        removeButton.style.display = "";
      }
      // Append the cloned field to the container
      this.containerTarget.appendChild(newField);
    }
    if (this.containerTarget.childElementCount >= this.limitValue) {
      this.addButtonTarget.remove();
      this.limitMessageTarget.style.display = "";
    }
  }

  removeInstrument(event) {
    const field = event.target.closest("[data-instruments-target='field']");
    const index = Array.from(this.fieldTargets).indexOf(field) + 1;
    if (index > 1) {
      const instrumentName = this.labelTargets[index - 1]?.textContent;
      if (instrumentName) {
        alert(`Removing instrument ${index}: ${instrumentName}`);
      }
      field.remove();
      this.updateLabels();
      if (this.containerTarget.childElementCount < this.limitValue) {
        this.limitMessageTarget.style.display = "none";
      }
    }
  }

  updateLabels() {
    this.labelTargets.forEach((label, index) => {
      label.textContent = `Artist instrument ${index + 1}`
    })
  }
}
