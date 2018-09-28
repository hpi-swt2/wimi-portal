class RemoveTripsHolidaysExpenses < ActiveRecord::Migration
  def change
    drop_table :expense_items
    drop_table :expenses
    drop_table :trips
    drop_table :holidays
  end
end
