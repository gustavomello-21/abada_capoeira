class RegistrationAnswer < ApplicationRecord
  belongs_to :registration
  belongs_to :event_field
end
