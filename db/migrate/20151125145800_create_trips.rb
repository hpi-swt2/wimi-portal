class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :name
      t.string :destination
      t.text :reason
      t.date :start_date
      t.date :end_date
      t.integer :days_abroad
      t.text :annotation
      t.string :signature

      t.timestamps null: false
    end
  end
end
