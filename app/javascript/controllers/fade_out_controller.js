import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fade-out"
export default class extends Controller {
  connect() {
    console.log('FadeOutController connected');
    this.updateFadeOut();
    window.addEventListener('resize', this.updateFadeOut);
  }

  disconnect() {
    window.removeEventListener('resize', this.updateFadeOut);
  }

  updateFadeOut = () => {
    try {
      console.log('updateFadeOut called');
      console.log('scrollWidth:', this.element.scrollWidth);
      console.log('clientWidth:', this.element.clientWidth);
      if (this.element.scrollWidth > this.element.clientWidth) {
        console.log('adding show-fade-out class');
        this.element.classList.add('show-fade-out');
      } else {
        console.log('removing show-fade-out class');
        this.element.classList.remove('show-fade-out');
      }
    } catch (error) {
      console.error(error);
    }
  }
}
