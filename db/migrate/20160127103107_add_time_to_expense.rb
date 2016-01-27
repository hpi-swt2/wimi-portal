class AddTimeToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :time_start, :string
    add_column :expenses, :time_end, :string
  end
end
