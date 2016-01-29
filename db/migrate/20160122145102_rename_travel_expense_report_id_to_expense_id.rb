class RenameTravelExpenseReportIdToExpenseId < ActiveRecord::Migration
  def change
  	rename_column :expense_items, :travel_expense_report_id, :expense_id
  end
end
