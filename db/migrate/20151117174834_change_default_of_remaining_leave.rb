class ChangeDefaultOfRemainingLeave < ActiveRecord::Migration
  def change
    remove_column :users, :remaining_leave
    add_column :users, :remaining_leave, :integer, default: 28
  end
end
