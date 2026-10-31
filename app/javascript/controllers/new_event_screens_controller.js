import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["step", "indicator", "progressBar"];

  connect() {
    this.currentStepIndex = 0;
    this.updateUI();
  }

  nextStep(event) {
    if (event) event.preventDefault();

    const currentStep = this.stepTargets[this.currentStepIndex];
    if (!currentStep) return;

    // Validate inputs inside the current step before advancing
    const inputs = currentStep.querySelectorAll("input, select, textarea");
    for (const input of inputs) {
      if (input.required && !input.value.trim()) {
        input.reportValidity();
        input.focus();
        return;
      }
    }

    if (this.currentStepIndex < this.stepTargets.length - 1) {
      this.currentStepIndex++;
      this.updateUI();
      window.scrollTo({ top: 0, behavior: "smooth" });
    }
  }

  previousStep(event) {
    if (event) event.preventDefault();

    if (this.currentStepIndex > 0) {
      this.currentStepIndex--;
      this.updateUI();
      window.scrollTo({ top: 0, behavior: "smooth" });
    }
  }

  goToStep(event) {
    const targetStep = parseInt(event.currentTarget.dataset.stepIndex, 10);
    if (!isNaN(targetStep) && targetStep < this.currentStepIndex) {
      this.currentStepIndex = targetStep;
      this.updateUI();
    }
  }

  updateUI() {
    this.stepTargets.forEach((step, idx) => {
      if (idx === this.currentStepIndex) {
        step.classList.remove("d-none");
      } else {
        step.classList.add("d-none");
      }
    });

    if (this.hasIndicatorTargets) {
      this.indicatorTargets.forEach((indicator, idx) => {
        if (idx === this.currentStepIndex) {
          indicator.classList.add("active");
          indicator.classList.remove("completed");
        } else if (idx < this.currentStepIndex) {
          indicator.classList.remove("active");
          indicator.classList.add("completed");
        } else {
          indicator.classList.remove("active", "completed");
        }
      });
    }

    if (this.hasProgressBarTarget) {
      const percentage = ((this.currentStepIndex + 1) / this.stepTargets.length) * 100;
      this.progressBarTarget.style.width = `${percentage}%`;
    }
  }
}
