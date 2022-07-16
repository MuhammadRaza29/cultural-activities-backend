class Event < ApplicationRecord

  # Associations
  has_one :category
  has_one :event_venue

end
