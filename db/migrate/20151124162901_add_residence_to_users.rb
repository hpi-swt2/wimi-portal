class AddResidenceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :residence, :string
  end
end
