class AddRejectionMessageToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :rejection_message, :text
  end
end
