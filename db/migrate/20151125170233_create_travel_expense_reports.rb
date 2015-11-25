class CreateTravelExpenseReports < ActiveRecord::Migration
  def change
    create_table :travel_expense_reports do |t|
      t.string :name
      t.integer :advance
      t.references :trip, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
