class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.string :status
      t.datetime :start
      t.datetime :end
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :holidays, :user_id
  end
end
