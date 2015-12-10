class CreateTravelExpenseReports < ActiveRecord::Migration
  def change
    create_table :travel_expense_reports do |t|
      t.string :first_name
      t.string :last_name
      t.boolean :inland
      t.string :country
      t.string :location_from
      t.string :location_via
      t.string :location_to
      t.text :reason
      t.datetime :date_start
      t.datetime :date_end
      t.boolean :car
      t.boolean :public_transport
      t.boolean :vehicle_advance
      t.boolean :hotel
      t.integer :general_advance
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
