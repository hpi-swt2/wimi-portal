class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.decimal :amount
      t.text :purpose
      t.text :comment
      t.integer :user_id
      t.belongs_to :user, index: true
      t.belongs_to :project, index: true
      t.belongs_to :trip, index: true
      t.timestamps null: false
    end
  end
end
