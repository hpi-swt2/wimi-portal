class AddOpenIdFieldsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :identity_url, :string
  end
  def down
    remove_column :users, :identity_url
  end
end
