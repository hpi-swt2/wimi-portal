class WorkDayProject < ActiveRecord::Migration
  def change
      add_column :work_days, :project_id, :integer
  end
end
