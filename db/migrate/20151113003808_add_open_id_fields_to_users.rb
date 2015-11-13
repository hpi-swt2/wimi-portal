class AddOpenIdFieldsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :identity_url, :string
    add_column :users, :username, :string 
    add_column :users, :token, :string
  end
  def down
    remove_column :users, :identity_url
    remove_column :users, :username
    remove_column :users, :token
  end
end 
