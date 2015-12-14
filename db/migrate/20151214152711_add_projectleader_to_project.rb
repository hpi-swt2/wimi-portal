class AddProjectleaderToProject < ActiveRecord::Migration
    def change
      add_column :projects, :project_leader, :string, default: ''
    end
  end
