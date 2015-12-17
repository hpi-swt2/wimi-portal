class RemoveNotification < ActiveRecord::Migration
  def change
    drop_table :notifications
  end
end
