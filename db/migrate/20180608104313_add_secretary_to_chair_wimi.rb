class AddSecretaryToChairWimi < ActiveRecord::Migration
  def change
    add_column :chair_wimis, :secretary, :boolean
  end
end
