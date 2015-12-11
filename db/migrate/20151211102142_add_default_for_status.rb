class AddDefaultForStatus < ActiveRecord::Migration
  def change
    add_column :trips, :status, :integer, default: 1
    change_column :holidays, :status, :integer, default: 1
    add_column :expenses, :status, :integer, default: 1
  end
end
