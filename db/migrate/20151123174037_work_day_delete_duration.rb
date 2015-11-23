class WorkDayDeleteDuration < ActiveRecord::Migration
  def change
      remove_column :work_days, :duration
  end
end
