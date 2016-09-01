class RemoveRelationsFromWorkDays < ActiveRecord::Migration
  def change
    remove_column :work_days, :user_id, :integer
    remove_column :work_days, :project_id, :integer
  end
end
