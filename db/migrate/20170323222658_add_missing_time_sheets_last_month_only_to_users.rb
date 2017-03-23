class AddMissingTimeSheetsLastMonthOnlyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :missing_ts_last_month_only, :boolean
  end
end
