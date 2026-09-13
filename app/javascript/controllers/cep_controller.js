import { Controller } from "@hotwired/stimulus"

// Aplica máscara de CEP e, quando o CEP fica completo, busca o endereço no
// ViaCEP para preencher rua, bairro, cidade e UF automaticamente.
export default class extends Controller {
  static targets = ["zip", "street", "neighborhood", "city", "state"]

  connect() {
    this.mask()
  }

  mask() {
    const digits = this.zipTarget.value.replace(/\D/g, "").slice(0, 8)
    this.zipTarget.value = digits.length > 5 ? `${digits.slice(0, 5)}-${digits.slice(5)}` : digits

    if (digits.length === 8) this.lookup(digits)
  }

  async lookup(cep) {
    this.setLoading(true)

    try {
      const response = await fetch(`https://viacep.com.br/ws/${cep}/json/`, {
        headers: { Accept: "application/json" }
      })
      if (!response.ok) return

      const data = await response.json()
      if (data.erro) return

      if (this.hasStreetTarget && data.logradouro) this.streetTarget.value = data.logradouro
      if (this.hasNeighborhoodTarget && data.bairro) this.neighborhoodTarget.value = data.bairro
      if (this.hasCityTarget && data.localidade) this.cityTarget.value = data.localidade
      if (this.hasStateTarget && data.uf) this.stateTarget.value = data.uf
    } catch (error) {
      // Sem internet ou ViaCEP indisponível: o usuário preenche manualmente.
    } finally {
      this.setLoading(false)
    }
  }

  setLoading(isLoading) {
    this.zipTarget.classList.toggle("opacity-50", isLoading)
  }
}
