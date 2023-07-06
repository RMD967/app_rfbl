import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="upload-content"
export default class extends Controller {
  static targets = ['uploadModal', 'fileInput'];

  connect() {
    // Initialize Bootstrap modal
    console.log('Controller connected');
    $(this.uploadModalTarget).modal({
      show: false
    });
  }

  toggleModal(event) {
    console.log('Toggle modal function called');
    event.preventDefault();
    $(this.uploadModalTarget).modal('toggle');
  }

  closeModal() {
    console.log('Close modal function called');
    $(this.uploadModalTarget).modal('hide');
  }

  clearFileInputs() {
    console.log('Clear file inputs function called');
    this.fileInputTargets.forEach((input) => {
      input.value = '';
    });
  }

  initialize() {
    this.element.addEventListener('click', this.toggleModal.bind(this));
    $(this.uploadModalTarget).on('hidden.bs.modal', this.clearFileInputs.bind(this));
  }
}
