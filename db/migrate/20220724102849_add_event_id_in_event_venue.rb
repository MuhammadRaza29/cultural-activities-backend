class AddEventIdInEventVenue < ActiveRecord::Migration[7.0]
  def change
    add_reference :event_venues, :event, foreign_key: true
  end
end
