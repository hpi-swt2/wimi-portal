class ChangeTripSignatureToBoolean < ActiveRecord::Migration
  def change
    remove_column :trips, :signature, :string
    add_column :trips, :signature, :boolean
  end
end
