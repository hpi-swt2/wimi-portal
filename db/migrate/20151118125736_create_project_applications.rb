class CreateProjectApplications < ActiveRecord::Migration
  def change
    create_table :project_applications do |t|
      t.integer :project_id
      t.integer :user_id
      t.integer :status

      t.timestamps null: false
    end
  end
end
