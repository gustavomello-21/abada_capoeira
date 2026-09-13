class EventField < ApplicationRecord
  belongs_to :event

  enum :field_type, { text: 0, number: 1, date: 2, choice: 3, checkbox: 4, textarea: 5 }

  FIELD_TYPE_LABELS = {
    "text" => "Texto curto",
    "number" => "Número",
    "date" => "Data",
    "choice" => "Múltipla escolha",
    "checkbox" => "Sim/Não",
    "textarea" => "Texto longo"
  }.freeze

  validates :label, presence: true

  def self.human_field_type(key)
    FIELD_TYPE_LABELS.fetch(key.to_s, key.to_s.humanize)
  end

  def options=(value)
    value = value.to_json if value.is_a?(Array)
    super
  end

  def options_array
    return [] if options.blank?

    JSON.parse(options)
  rescue JSON::ParserError
    []
  end

  def options_text
    options_array.join("\n")
  end

  def options_text=(text)
    self.options = text.to_s.split("\n").map(&:strip).reject(&:blank?)
  end
end
