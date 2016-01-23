class AddDefaultForStatus < ActiveRecord::Migration
  def change
    add_column :trips, :status, :integer, default: 0
    remove_column :holidays, :status
    add_column :holidays, :status, :integer, default: 0
  end
end
