class RemoveAttendanceFromWorkDays < ActiveRecord::Migration
  def change
    remove_column :work_days, :attendance, :string
  end
end
