class AddRemainingLeaveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remaining_leave, :integer
  end
end
