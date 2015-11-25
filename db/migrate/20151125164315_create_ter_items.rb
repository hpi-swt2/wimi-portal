class CreateTerItems < ActiveRecord::Migration
  def change
    create_table :ter_items do |t|
      t.decimal :amount
      t.string :purpose
      t.references :travel_expense_report, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
