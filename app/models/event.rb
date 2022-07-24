class Event < ApplicationRecord

  # Associations
  belongs_to :category, optional: true
  has_one :event_venue, dependent: :destroy

  # Enums
  enum status: { active: 0, expired: 1 }

  accepts_nested_attributes_for :event_venue, allow_destroy: true
end
