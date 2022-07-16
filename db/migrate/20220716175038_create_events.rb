class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :web_source
      t.string :url
      t.string :picture_url
      t.integer :status, default: 0
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time
      t.timestamps
    end
  end
end
