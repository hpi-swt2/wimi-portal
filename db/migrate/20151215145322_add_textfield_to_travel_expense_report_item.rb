class AddTextfieldToTravelExpenseReportItem < ActiveRecord::Migration
  def change
    add_column :travel_expense_report_items, :annotation, :text
  end
end
