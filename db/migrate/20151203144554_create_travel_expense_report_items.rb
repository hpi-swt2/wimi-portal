class CreateTravelExpenseReportItems < ActiveRecord::Migration
  def change
    create_table :travel_expense_report_items do |t|
      t.date :date
      t.boolean :breakfast
      t.boolean :lunch
      t.boolean :dinner
      t.references :travel_expense_report, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
