class UserProjectSalary < ActiveRecord::Migration
  def change
      add_column :projects_users, :salary, :integer
  end
end
