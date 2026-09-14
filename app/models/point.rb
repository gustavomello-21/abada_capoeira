class Point < ApplicationRecord
  BRAZILIAN_STATES = [
    [ "Acre", "AC" ], [ "Alagoas", "AL" ], [ "Amapá", "AP" ], [ "Amazonas", "AM" ],
    [ "Bahia", "BA" ], [ "Ceará", "CE" ], [ "Distrito Federal", "DF" ], [ "Espírito Santo", "ES" ],
    [ "Goiás", "GO" ], [ "Maranhão", "MA" ], [ "Mato Grosso", "MT" ], [ "Mato Grosso do Sul", "MS" ],
    [ "Minas Gerais", "MG" ], [ "Pará", "PA" ], [ "Paraíba", "PB" ], [ "Paraná", "PR" ],
    [ "Pernambuco", "PE" ], [ "Piauí", "PI" ], [ "Rio de Janeiro", "RJ" ], [ "Rio Grande do Norte", "RN" ],
    [ "Rio Grande do Sul", "RS" ], [ "Rondônia", "RO" ], [ "Roraima", "RR" ], [ "Santa Catarina", "SC" ],
    [ "São Paulo", "SP" ], [ "Sergipe", "SE" ], [ "Tocantins", "TO" ]
  ].freeze

  has_one_attached :photo

  geocoded_by :full_street_address
  after_validation :geocode, if: :address_changed?
  after_validation :update_geocode_status

  validates :teacher_name, :phone, :street, :city, :state, presence: true

  scope :geocoded, -> { where.not(latitude: nil, longitude: nil) }

  def full_street_address
    [ street, number, neighborhood, city, state, zip_code, "Brasil" ].compact_blank.join(", ")
  end

  # Geocodifica tentando primeiro o endereço mais completo e "recuando" para
  # versões mais simples caso não encontre resultado.
  #
  # O bairro é preenchido automaticamente pelo ViaCEP a partir do CEP, mas o
  # nome oficial dos Correios nem sempre bate com o nome que o OpenStreetMap
  # usa pra mesma área — quando isso acontece, incluir o bairro na busca faz
  # o Nominatim não encontrar nada. Por isso ele fica de fora das tentativas
  # de geocodificação (o bairro continua sendo salvo e exibido normalmente
  # em full_street_address).
  def geocode
    geocode_search_candidates.each do |address|
      result = Geocoder.search(address).first
      next unless result

      self.latitude = result.latitude
      self.longitude = result.longitude
      return
    end

    self.latitude = nil
    self.longitude = nil
  end

  def address_changed?
    street_changed? || number_changed? || neighborhood_changed? || city_changed? || state_changed? || zip_code_changed?
  end

  def self.near_ordered(lat, lng)
    geocoded.to_a.sort_by { |point| Geocoder::Calculations.distance_between([ lat, lng ], [ point.latitude, point.longitude ]) }
  end

  private

  def geocode_search_candidates
    [
      [ street, number, city, state, zip_code, "Brasil" ],
      [ street, city, state, "Brasil" ],
      [ city, state, "Brasil" ]
    ].map { |parts| parts.compact_blank.join(", ") }.uniq.reject(&:blank?)
  end

  def update_geocode_status
    self.geocode_status = latitude.present? && longitude.present? ? "success" : "failed"
  end
end
