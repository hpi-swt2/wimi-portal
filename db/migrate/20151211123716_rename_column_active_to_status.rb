class RenameColumnActiveToStatus < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.rename :active, :status
    end
  end
end
