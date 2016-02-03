class RemoveLocationToFromExpense < ActiveRecord::Migration
  def change
    remove_column :expenses, :location_to
  end
end
