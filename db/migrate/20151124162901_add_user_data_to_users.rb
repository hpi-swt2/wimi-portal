class AddUserDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :residence, :string
    add_column :users, :street, :string
    add_column :users, :division, :string
    add_column :users, :personnel_number, :integer
  end
end
