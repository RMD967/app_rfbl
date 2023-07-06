import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["target"];
  static values = { artistTravel: Boolean };

  connect() {
    console.log("toggle controller connected");
    this.toggle(); // Call toggle initially to set the initial state
  }

  toggle() {
    const isArtistTravel = this.artistTravelValue;
    console.log("isArtistTravel:", isArtistTravel);
    this.targetTargets.forEach((target) => {
      target.classList.toggle("hidden", !isArtistTravel);
    });
  }
}
