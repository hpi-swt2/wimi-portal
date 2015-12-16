class AddSignatureToTravelExpenseReports < ActiveRecord::Migration
  def change
    add_column :travel_expense_reports, :signature, :boolean
  end
end
