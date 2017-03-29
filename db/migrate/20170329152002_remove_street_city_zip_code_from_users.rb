class RemoveStreetCityZipCodeFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :street, :string
    remove_column :users, :city, :string
    remove_column :users, :zip_code, :string
  end
end
