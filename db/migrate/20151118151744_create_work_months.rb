class CreateWorkMonths < ActiveRecord::Migration
  def change
    create_table :work_months do |t|
      t.string :name
      t.integer :year

      t.timestamps null: false
    end
  end
end
