class AddTripToExpense < ActiveRecord::Migration
  def change
    add_reference :expenses, :trip, index: true, foreign_key: true
  end
end
