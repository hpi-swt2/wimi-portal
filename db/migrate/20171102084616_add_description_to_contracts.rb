class AddDescriptionToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :description, :text
  end
end
