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

    console.log("Create Event button clicked!"); // Check if the button click event is detected

    const form = event.target.closest("form");
    if (form) {
      const formData = new FormData(form);
      console.log("Form data:", formData); // Check if the form data is captured correctly

      const url = form.getAttribute("action");
      console.log("Form action URL:", url); // Check if the form action URL is correct

      // Comment out the fetch request for now to isolate the issue
      /*
      fetch(url, {
        method: "POST",
        body: formData,
      })
        .then(response => response.json())
        .then(data => {
          console.log("Event created!", data);
          // Optionally, you can perform any additional actions after event creation
        })
        .catch(error => {
          console.error("Error creating event:", error);
          // Optionally, you can handle the error or display an error message
        });
      */
    }
  }


  getCurrentStep() {
    return this.stepTargets.find((step) => !step.classList.contains("d-none"));
  }
}
