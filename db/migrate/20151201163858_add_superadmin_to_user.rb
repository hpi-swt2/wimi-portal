class AddSuperadminToUser < ActiveRecord::Migration
  def change
  	rename_column :users, :first, :first_name
  	add_column :users, :superadmin, :boolean, default: false
  end
end
