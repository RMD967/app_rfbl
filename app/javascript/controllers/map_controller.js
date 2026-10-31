// app/javascript/controllers/map_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/dark-v11"
    })
    this.element._mapboxMap = this.map

    this.#addMarkersToMap()
    this.#fitMapToMarkers()

    this.resizeHandler = () => {
      if (this.map) this.map.resize()
    }
    window.addEventListener("resize", this.resizeHandler)
  }

  disconnect() {
    if (this.resizeHandler) {
      window.removeEventListener("resize", this.resizeHandler)
    }
    if (this.map) {
      this.map.remove()
    }
  }



  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html) // Add this
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup) // Add this
        .addTo(this.map)
    })
  }

  #fitMapToMarkers() {
    if (!this.markersValue || this.markersValue.length === 0) return
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}
