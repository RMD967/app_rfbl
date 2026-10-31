import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["listView", "mapView", "listBtn", "mapBtn", "mapContainer"]

  connect() {
    const urlParams = new URLSearchParams(window.location.search)
    if (urlParams.get("view") === "map") {
      this.showMap()
    }
  }

  showList(event) {
    if (event) event.preventDefault()
    if (this.hasListViewTarget) this.listViewTarget.classList.remove("d-none")
    if (this.hasMapViewTarget) this.mapViewTarget.classList.add("d-none")

    if (this.hasListBtnTarget) {
      this.listBtnTarget.classList.add("active")
      this.listBtnTarget.setAttribute("aria-pressed", "true")
    }
    if (this.hasMapBtnTarget) {
      this.mapBtnTarget.classList.remove("active")
      this.mapBtnTarget.setAttribute("aria-pressed", "false")
    }
  }

  showMap(event) {
    if (event) event.preventDefault()
    if (this.hasListViewTarget) this.listViewTarget.classList.add("d-none")
    if (this.hasMapViewTarget) this.mapViewTarget.classList.remove("d-none")

    if (this.hasListBtnTarget) {
      this.listBtnTarget.classList.remove("active")
      this.listBtnTarget.setAttribute("aria-pressed", "false")
    }
    if (this.hasMapBtnTarget) {
      this.mapBtnTarget.classList.add("active")
      this.mapBtnTarget.setAttribute("aria-pressed", "true")
    }

    // Trigger map resize so Mapbox renders without gray area
    setTimeout(() => {
      window.dispatchEvent(new Event("resize"))
      if (this.hasMapContainerTarget && this.mapContainerTarget._mapboxMap) {
        this.mapContainerTarget._mapboxMap.resize()
      }
    }, 150)
  }

  toggleView(event) {
    if (event) event.preventDefault()
    if (this.hasMapViewTarget && this.mapViewTarget.classList.contains("d-none")) {
      this.showMap()
    } else {
      this.showList()
    }
  }
}
