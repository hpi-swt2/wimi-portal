class DeleteDateFromExpense < ActiveRecord::Migration
  def change
  	remove_column :expenses, :date_start
  	remove_column :expenses, :date_end
  end
end
