class AddRemainingLeaveNextYear < ActiveRecord::Migration
  def change
  	remove_column :users, :remaining_leave
  	add_column :users, :remaining_leave_this_year, :integer, default: 28
  	add_column :users, :remaining_leave_next_year, :integer, default: 28
  end
end
