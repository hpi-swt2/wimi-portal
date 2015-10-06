class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.decimal :amount
      t.text :purpose
      t.text :comment
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
