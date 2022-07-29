class Event < ApplicationRecord

  # Associations
  belongs_to :category, optional: true
  has_one :event_venue, dependent: :destroy

  # Enums
  enum status: { active: 0, expired: 1 }

  accepts_nested_attributes_for :event_venue, allow_destroy: true

  delegate :name, to: :event_venue, allow_nil: true, prefix: true
  delegate :name, to: :category, allow_nil: true, prefix: true

  # Scopes
  scope :active, -> { where(status: statuses[:active]) }
  scope :search_by, ->(column, value) { where("LOWER(#{column}) LIKE LOWER(?)", "%#{value}%") }
  scope :search_by_date, ->(date) { where("DATE(start_date) = ? OR DATE(end_date) = ?", date, date) }
end
