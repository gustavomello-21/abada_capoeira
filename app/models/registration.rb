class Registration < ApplicationRecord
  belongs_to :event
  belongs_to :user

  has_many :registration_answers, dependent: :destroy
  has_one_attached :payment_proof

  accepts_nested_attributes_for :registration_answers

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  validates :user_id, uniqueness: { scope: :event_id }
  validate :all_required_fields_answered

  def answer_for(event_field)
    registration_answers.find { |answer| answer.event_field_id == event_field.id }
  end

  private

  def all_required_fields_answered
    event.event_fields.where(required: true).find_each do |field|
      answer = answer_for(field)
      errors.add(:base, "#{field.label} é obrigatório") if answer.nil? || answer.value.blank?
    end
  end
end
