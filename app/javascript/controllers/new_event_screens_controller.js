import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "step",
    "indicator",
    "progressBar",
    "form",
    // Step 1
    "titleInput",
    "genreSelect",
    "descriptionInput",
    "titleError",
    "genreError",
    "descriptionError",
    // Step 2
    "addressInput",
    "addressError",
    "fileInput",
    "unselectedBox",
    "previewBox",
    "previewImg",
    "fileName",
    // Step 3
    "dateInput",
    "timeInput",
    "datetimeHidden",
    "dateError",
    "timeError",
    "durationInput",
    "durationError",
    "durationSummary"
  ];

  static values = {
    initialStep: { type: Number, default: 0 }
  };

  connect() {
    this.currentStepIndex = this.hasInitialStepValue ? this.initialStepValue : 0;
    this.updateUI();
    this.initDateTimeAndDuration();
  }

  // ---------------- Navigation ----------------
  nextStep(event) {
    if (event) event.preventDefault();

    // Validate current step before advancing
    if (!this.validateCurrentStep()) {
      return;
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

  // ---------------- Validation ----------------
  validateCurrentStep() {
    if (this.currentStepIndex === 0) {
      return this.validateStep1();
    } else if (this.currentStepIndex === 1) {
      return this.validateStep2();
    }
    return true;
  }

  validateStep1() {
    let isValid = true;

    // Title
    if (this.hasTitleInputTarget) {
      if (!this.titleInputTarget.value.trim()) {
        this.titleInputTarget.classList.add("is-invalid");
        if (this.hasTitleErrorTarget) this.titleErrorTarget.classList.remove("d-none");
        isValid = false;
      } else {
        this.titleInputTarget.classList.remove("is-invalid");
        if (this.hasTitleErrorTarget) this.titleErrorTarget.classList.add("d-none");
      }
    }

    // Genre
    if (this.hasGenreSelectTarget) {
      if (!this.genreSelectTarget.value.trim()) {
        this.genreSelectTarget.classList.add("is-invalid");
        if (this.hasGenreErrorTarget) this.genreErrorTarget.classList.remove("d-none");
        isValid = false;
      } else {
        this.genreSelectTarget.classList.remove("is-invalid");
        if (this.hasGenreErrorTarget) this.genreErrorTarget.classList.add("d-none");
      }
    }

    // Description
    if (this.hasDescriptionInputTarget) {
      if (!this.descriptionInputTarget.value.trim()) {
        this.descriptionInputTarget.classList.add("is-invalid");
        if (this.hasDescriptionErrorTarget) this.descriptionErrorTarget.classList.remove("d-none");
        isValid = false;
      } else {
        this.descriptionInputTarget.classList.remove("is-invalid");
        if (this.hasDescriptionErrorTarget) this.descriptionErrorTarget.classList.add("d-none");
      }
    }

    return isValid;
  }

  validateStep2() {
    let isValid = true;

    if (this.hasAddressInputTarget) {
      // Mapbox address input or geocoder
      const val = this.addressInputTarget.value.trim();
      const geocoderInput = this.element.querySelector(".mapboxgl-ctrl-geocoder input");
      const geocoderVal = geocoderInput ? geocoderInput.value.trim() : "";

      if (!val && !geocoderVal) {
        if (geocoderInput) geocoderInput.classList.add("is-invalid");
        if (this.hasAddressErrorTarget) this.addressErrorTarget.classList.remove("d-none");
        isValid = false;
      } else {
        if (geocoderInput) geocoderInput.classList.remove("is-invalid");
        if (this.hasAddressErrorTarget) this.addressErrorTarget.classList.add("d-none");
      }
    }

    return isValid;
  }

  validateStep3() {
    let isValid = true;

    // Date
    if (this.hasDateInputTarget) {
      if (!this.dateInputTarget.value.trim()) {
        this.dateInputTarget.classList.add("is-invalid");
        if (this.hasDateErrorTarget) this.dateErrorTarget.classList.remove("d-none");
        isValid = false;
      } else {
        this.dateInputTarget.classList.remove("is-invalid");
        if (this.hasDateErrorTarget) this.dateErrorTarget.classList.add("d-none");
      }
    }

    // Time
    if (this.hasTimeInputTarget) {
      if (!this.timeInputTarget.value.trim()) {
        this.timeInputTarget.classList.add("is-invalid");
        if (this.hasTimeErrorTarget) this.timeErrorTarget.classList.remove("d-none");
        isValid = false;
      } else {
        this.timeInputTarget.classList.remove("is-invalid");
        if (this.hasTimeErrorTarget) this.timeErrorTarget.classList.add("d-none");
      }
    }

    // Duration
    if (this.hasDurationInputTarget) {
      const mins = parseInt(this.durationInputTarget.value, 10);
      if (isNaN(mins) || mins < 30) {
        this.durationInputTarget.classList.add("is-invalid");
        if (this.hasDurationErrorTarget) this.durationErrorTarget.classList.remove("d-none");
        isValid = false;
      } else {
        this.durationInputTarget.classList.remove("is-invalid");
        if (this.hasDurationErrorTarget) this.durationErrorTarget.classList.add("d-none");
      }
    }

    return isValid;
  }

  submitWizard(event) {
    if (event) event.preventDefault();

    // Validate Step 3
    if (!this.validateStep3()) {
      return;
    }

    // Also double-check Step 1 and Step 2 in case they bypassed
    if (!this.validateStep1()) {
      this.currentStepIndex = 0;
      this.updateUI();
      return;
    }

    if (!this.validateStep2()) {
      this.currentStepIndex = 1;
      this.updateUI();
      return;
    }

    // Ensure hidden datetime is synced
    this.updateDateTime();

    // Submit form
    const form = this.hasFormTarget ? this.formTarget : this.element.querySelector("form");
    if (form) {
      form.submit();
    }
  }

  // ---------------- Date & Time Helpers ----------------
  initDateTimeAndDuration() {
    if (this.hasDatetimeHiddenTarget && this.datetimeHiddenTarget.value) {
      const parts = this.datetimeHiddenTarget.value.split("T");
      if (parts[0] && this.hasDateInputTarget && !this.dateInputTarget.value) {
        this.dateInputTarget.value = parts[0];
      }
      if (parts[1] && this.hasTimeInputTarget && !this.timeInputTarget.value) {
        this.timeInputTarget.value = parts[1].slice(0, 5);
      }
    }

    if (this.hasDurationInputTarget) {
      const mins = parseInt(this.durationInputTarget.value, 10) || 120;
      this.updateDurationUI(mins);
    }
  }

  updateDateTime() {
    const date = this.hasDateInputTarget ? this.dateInputTarget.value : "";
    const time = this.hasTimeInputTarget ? this.timeInputTarget.value : "";

    if (this.hasDateErrorTarget && date) this.dateErrorTarget.classList.add("d-none");
    if (this.hasTimeErrorTarget && time) this.timeErrorTarget.classList.add("d-none");
    if (this.hasDateInputTarget && date) this.dateInputTarget.classList.remove("is-invalid");
    if (this.hasTimeInputTarget && time) this.timeInputTarget.classList.remove("is-invalid");

    if (date && time && this.hasDatetimeHiddenTarget) {
      this.datetimeHiddenTarget.value = `${date}T${time}`;
    }
  }

  setTimePreset(event) {
    event.preventDefault();
    const time = event.currentTarget.dataset.time;
    if (this.hasTimeInputTarget) {
      this.timeInputTarget.value = time;
      this.updateDateTime();
    }

    // Highlight active preset
    const buttons = this.element.querySelectorAll(".time-presets-row .preset-pill");
    buttons.forEach(btn => btn.classList.remove("active"));
    event.currentTarget.classList.add("active");
  }

  // ---------------- Duration Presets ----------------
  setDurationPreset(event) {
    event.preventDefault();
    const mins = parseInt(event.currentTarget.dataset.minutes, 10);
    if (!isNaN(mins)) {
      if (this.hasDurationInputTarget) {
        this.durationInputTarget.value = mins;
      }
      this.updateDurationUI(mins);
    }

    const buttons = this.element.querySelectorAll(".duration-presets-grid .duration-pill");
    buttons.forEach(btn => btn.classList.remove("active"));
    event.currentTarget.classList.add("active");
  }

  onDurationInput(event) {
    const mins = parseInt(event.target.value, 10);
    this.updateDurationUI(mins);

    // Unselect presets if custom value doesn't match
    const buttons = this.element.querySelectorAll(".duration-presets-grid .duration-pill");
    buttons.forEach(btn => {
      const btnMins = parseInt(btn.dataset.minutes, 10);
      if (btnMins === mins) {
        btn.classList.add("active");
      } else {
        btn.classList.remove("active");
      }
    });
  }

  updateDurationUI(mins) {
    if (!mins || isNaN(mins) || mins < 30) {
      if (this.hasDurationSummaryTarget) {
        this.durationSummaryTarget.innerHTML = `<i class="ri-alert-line text-warning"></i> Mínimo 30 minutos`;
      }
      return;
    }

    if (this.hasDurationInputTarget) {
      this.durationInputTarget.classList.remove("is-invalid");
    }
    if (this.hasDurationErrorTarget) {
      this.durationErrorTarget.classList.add("d-none");
    }

    if (this.hasDurationSummaryTarget) {
      let label = "";
      if (mins < 60) {
        label = `${mins} minutos`;
      } else if (mins % 60 === 0) {
        const h = mins / 60;
        label = `${h} ${h === 1 ? "hora" : "horas"} (${mins} min)`;
      } else {
        const h = Math.floor(mins / 60);
        const m = mins % 60;
        label = `${h}h ${m}m (${mins} min)`;
      }
      this.durationSummaryTarget.innerHTML = `<i class="ri-check-line"></i> ${label}`;
    }
  }

  // ---------------- File Preview ----------------
  triggerFileInput() {
    if (this.hasFileInputTarget) {
      this.fileInputTarget.click();
    }
  }

  previewFile(event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        if (this.hasPreviewImgTarget) {
          this.previewImgTarget.src = e.target.result;
        }
        if (this.hasFileNameTarget) {
          this.fileNameTarget.textContent = file.name;
        }
        if (this.hasUnselectedBoxTarget) {
          this.unselectedBoxTarget.classList.add("d-none");
        }
        if (this.hasPreviewBoxTarget) {
          this.previewBoxTarget.classList.remove("d-none");
        }
      };
      reader.readAsDataURL(file);
    }
  }
}
