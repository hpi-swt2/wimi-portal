class CreateTimeSheets < ActiveRecord::Migration
  def change
    create_table :time_sheets do |t|
      t.integer :month
      t.integer :yeat
      t.integer :salary
      t.boolean :salary_is_per_month
      t.integer :workload
      t.boolean :workload_is_per_month
      t.integer :user_id
      t.integer :project_id

      t.timestamps null: false
    end

    remove_column :projects_users, :salary
  end
end
