import { Controller } from "@hotwired/stimulus"

// Aplica máscara de telefone brasileiro (fixo ou celular) enquanto o usuário digita.
export default class extends Controller {
  connect() {
    this.format()
  }

  format() {
    const digits = this.element.value.replace(/\D/g, "").slice(0, 11)
    this.element.value = this.mask(digits)
  }

  mask(digits) {
    const ddd = digits.slice(0, 2)
    const rest = digits.slice(2)

    let out = ddd.length ? `(${ddd}` : ""
    if (ddd.length === 2) out += ") "

    if (digits.length > 10) {
      // celular: 5 dígitos + 4
      out += rest.slice(0, 5)
      if (rest.length > 5) out += `-${rest.slice(5)}`
    } else {
      // fixo: 4 dígitos + 4
      out += rest.slice(0, 4)
      if (rest.length > 4) out += `-${rest.slice(4)}`
    }

    return out
  }
}
