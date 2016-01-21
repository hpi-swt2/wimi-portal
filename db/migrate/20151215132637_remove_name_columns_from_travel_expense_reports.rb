class RemoveNameColumnsFromTravelExpenseReports < ActiveRecord::Migration
  def change
    remove_column :travel_expense_reports, :first_name, :string
    remove_column :travel_expense_reports, :last_name, :string
  end
end
