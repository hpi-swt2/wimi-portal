class AddUserDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :residence, :string
    add_column :users, :street, :string
    add_column :users, :division_id, :integer, default: 0
    add_column :users, :personnel_number, :integer, default: 0
  end
end
