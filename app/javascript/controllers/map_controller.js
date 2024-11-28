import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'


// Connects to data-controller="map"
export default class extends Controller {
  static values ={
    markers: Array,
    apiKey: String,
  }
  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v12"
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {

      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.marker_html
      console.log("LAG:", marker.lng);
      console.log('LAT', marker.lat);
      console.log('MAP:', this.map)

      new mapboxgl.Marker()
        .setLngLat([4.835235, 45.769531])
        .addTo(this.map)
        // .setPopup(popup)

    });
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}
