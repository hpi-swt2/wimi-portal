class AddTimestampsToTravelExpenseReport < ActiveRecord::Migration
  def change
    add_column :travel_expense_reports, :created_at, :datetime
    add_column :travel_expense_reports, :updated_at, :datetime
  end
end
