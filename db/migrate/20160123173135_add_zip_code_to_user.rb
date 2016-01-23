class AddZipCodeToUser < ActiveRecord::Migration
  def change
    remove_column :users, :residence
    add_column :users, :city, :string
    add_column :users, :zip_code, :string
  end
end
