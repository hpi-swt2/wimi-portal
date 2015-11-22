class WorkMonthRelations < ActiveRecord::Migration
  def change
      add_column :work_months, :user_id, :integer
      add_column :work_days, :work_month_id, :integer
  end
end
