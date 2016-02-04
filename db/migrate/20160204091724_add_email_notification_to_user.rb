class AddEmailNotificationToUser < ActiveRecord::Migration
  def change
    add_column :users, :email_notification, :boolean, default: false
  end
end
