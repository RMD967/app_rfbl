import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="upload"
export default class extends Controller {
  static targets = [ "form", "fileField" ]

  connect() {
    this.fileFieldTarget.addEventListener('change', () => {
      this.formTarget.submit();
    });
  }
}
