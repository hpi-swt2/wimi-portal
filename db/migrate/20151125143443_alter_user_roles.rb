class AlterUserRoles < ActiveRecord::Migration
  def change
    change_column :users, :role, :integer
  end
end
