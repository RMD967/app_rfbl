import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  get stepTargets() {
    return Array.from(this.element.querySelectorAll("[data-target='new-event-screens.step']"));
  }

  static targets = ["step"];

  connect() {
    this.stepTargets = Array.from(this.element.querySelectorAll("[data-target='new-event-screens.step']"));
    this.currentStep = 0;
  }


  nextStep() {
    const currentStep = this.stepTargets[this.currentStep];
    currentStep.classList.add("d-none");
    this.currentStep++;
    if (this.currentStep > this.stepTargets.length - 1) {
      this.currentStep = 0;
    }
    this.stepTargets[this.currentStep].classList.remove("d-none");
  }

  previousStep() {
    const currentStep = this.stepTargets[this.currentStep];
    currentStep.classList.add("d-none");
    this.currentStep--;
    if (this.currentStep < 0) {
      this.currentStep = this.stepTargets.length - 1;
    }
    this.stepTargets[this.currentStep].classList.remove("d-none");
  }
}
