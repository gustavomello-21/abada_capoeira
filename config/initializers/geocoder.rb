Geocoder.configure(
  lookup: :nominatim,
  units: :km,
  http_headers: { "User-Agent" => "AbadaCapoeira/1.0 (contato@abadacapoeira.local)" },
  cache: Rails.cache
)
