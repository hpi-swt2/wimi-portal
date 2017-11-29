class RemoveTripsHolidaysExpenses < ActiveRecord::Migration
  def change
    drop_table :trips
    drop_table :expenses
    drop_table :holidays
    drop_table :expense_items
  end
end
