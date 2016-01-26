class RenameTravelExpenseReportToExpense < ActiveRecord::Migration
  def change
  	rename_table :travel_expense_reports, :expenses
  	rename_table :travel_expense_report_items, :expense_items
  end
end
