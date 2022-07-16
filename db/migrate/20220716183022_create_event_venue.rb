class CreateEventVenue < ActiveRecord::Migration[7.0]
  def change
    create_table :event_venues do |t|
      t.string :name

      t.timestamps
    end
  end
end
