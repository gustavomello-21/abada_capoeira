import { Controller } from "@hotwired/stimulus"

const DEFAULT_CENTER = [-14.235, -51.9253] // centro geográfico do Brasil
const DEFAULT_ZOOM = 4

export default class extends Controller {
  static targets = ["canvas", "list", "query", "status"]
  static values = { pointsUrl: String, searchUrl: String }

  connect() {
    this.map = L.map(this.canvasTarget).setView(DEFAULT_CENTER, DEFAULT_ZOOM)

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 18,
      attribution: "&copy; colaboradores do OpenStreetMap"
    }).addTo(this.map)

    this.markers = []
    this.loadPoints(this.pointsUrlValue)
  }

  disconnect() {
    if (this.map) this.map.remove()
  }

  async loadPoints(url) {
    const response = await fetch(url, { headers: { Accept: "application/json" } })
    if (!response.ok) return
    const points = await response.json()
    this.renderPoints(points)
  }

  renderPoints(points) {
    this.markers.forEach((marker) => marker.remove())
    this.markers = []
    this.listTarget.innerHTML = ""

    if (points.length === 0) {
      this.listTarget.innerHTML = '<li class="p-4 text-sm text-gray-500">Nenhum ponto encontrado.</li>'
      return
    }

    points.forEach((point) => {
      const marker = L.marker([point.latitude, point.longitude]).addTo(this.map)
      marker.bindPopup(this.popupHtml(point))
      this.markers.push(marker)

      const li = document.createElement("li")
      li.className = "p-4 hover:bg-gray-50 cursor-pointer"
      li.innerHTML = `
        <p class="font-semibold text-gray-900">${this.escape(point.city)} - ${this.escape(point.state)}</p>
        <p class="text-sm text-gray-600">${this.escape(point.address)}</p>
        <p class="text-sm text-gray-500">Prof. ${this.escape(point.teacher_name)}</p>
      `
      li.addEventListener("click", () => {
        this.map.setView([point.latitude, point.longitude], 15)
        marker.openPopup()
      })
      this.listTarget.appendChild(li)
    })
  }

  popupHtml(point) {
    const photo = point.photo_url
      ? `<img src="${point.photo_url}" class="w-full h-24 object-cover rounded mb-2" />`
      : ""
    return `
      <div class="text-sm">
        ${photo}
        <p class="font-semibold">${this.escape(point.teacher_name)}</p>
        <p>${this.escape(point.address)}</p>
        <p>Tel: ${this.escape(point.phone)}</p>
        <a href="${point.show_url}" class="text-brand-700 underline">Ver detalhes</a>
      </div>
    `
  }

  async search(event) {
    event.preventDefault()
    const query = this.queryTarget.value.trim()
    if (!query) return

    this.setStatus("")

    const response = await fetch(`${this.searchUrlValue}?q=${encodeURIComponent(query)}`, {
      headers: { Accept: "application/json" }
    })

    if (!response.ok) {
      this.setStatus("Endereço não encontrado. Tente outro termo de busca.")
      return
    }

    const { lat, lng } = await response.json()
    this.map.setView([lat, lng], 12)
    this.loadPoints(`${this.pointsUrlValue}?lat=${lat}&lng=${lng}`)
  }

  setStatus(message) {
    this.statusTarget.textContent = message
    this.statusTarget.classList.toggle("hidden", !message)
  }

  escape(value) {
    const div = document.createElement("div")
    div.textContent = value ?? ""
    return div.innerHTML
  }
}
