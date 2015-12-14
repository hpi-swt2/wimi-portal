class AddDefaultForStatus < ActiveRecord::Migration
  def change
    change_column :trips, :status, :integer, default: 0
    change_column :holidays, :status, :integer, default: 0
    add_column :expenses, :status, :integer, default: 0
  end
end
