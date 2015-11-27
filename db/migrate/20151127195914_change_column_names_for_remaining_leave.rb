class ChangeColumnNamesForRemainingLeave < ActiveRecord::Migration
  def change
  	remove_column :holidays, :remaining_leave
  	remove_column :holidays, :remaining_leave_last_year
  	remove_column :users, :remaining_leave_this_year
  	remove_column :users, :remaining_leave_next_year
  	add_column :users, :remaining_leave, :integer, default: 28
  	add_column :users, :remaining_leave_last_year, :integer, default: 0
  end
end
