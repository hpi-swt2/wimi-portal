class AddProjectToWorkDay < ActiveRecord::Migration
  def change
    add_reference :work_days, :project, index: true, foreign_key: true
  end
end
