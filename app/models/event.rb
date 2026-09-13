class Event < ApplicationRecord
  has_rich_text :description

  has_many :event_fields, -> { order(:position, :id) }, dependent: :destroy
  has_many :registrations, dependent: :destroy

  accepts_nested_attributes_for :event_fields, allow_destroy: true

  enum :status, { draft: "draft", published: "published", closed: "closed" }, default: "draft"

  validates :title, presence: true

  scope :upcoming_first, -> { order(starts_at: :asc) }
end
