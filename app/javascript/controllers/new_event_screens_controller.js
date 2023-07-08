import { Controller } from "@hotwired/stimulus";


export default class extends Controller {
  static targets = ["step"];

  nextStep() {
    const currentStep = this.getCurrentStep();
    const nextStep = currentStep.nextElementSibling;

    currentStep.classList.add("d-none");
    nextStep.classList.remove("d-none");
  }

  previousStep() {
    const currentStep = this.getCurrentStep();
    const previousStep = currentStep.previousElementSibling;

    currentStep.classList.add("d-none");
    previousStep.classList.remove("d-none");
  }

  createEvent(event) {
    event.preventDefault();

    // Save the event information here
    // You can use an AJAX request or any other method to save the data

    console.log("Event created!"); // Example: Logging a message to the console

    // Optionally, you can submit the form manually
    const form = event.target.closest("form");
    if (form) {
      form.submit();
    }
  }

  getCurrentStep() {
    return this.stepTargets.find((step) => !step.classList.contains("d-none"));
  }
}
