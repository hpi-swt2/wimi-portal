class CreateTripDatespans < ActiveRecord::Migration
  def change
    create_table :trip_datespans do |t|
      t.date :start_date
      t.date :end_date
      t.integer :days_abroad
      t.references :trip, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
