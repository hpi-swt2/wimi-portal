class MigrateEmailSettings < ActiveRecord::Migration

  def up
    say_with_time "Setting full event_settings for all users who had notifications turned on" do
      counter = 0
      User.where(email_notification: true).find_each do |user|
        user.update(event_settings: Event.types.values)
        counter += 1
      end
      # If the result returned is an Integer, output includes a message
      # about the number of rows in addition to the elapsed time.
      counter
    end

    # Once existing data is migrated, remove email_notification column
    remove_column :users, :email_notification, :boolean
  end

  def down
    # Readd email_notification column
    add_column :users, :email_notification, :boolean

    say_with_time "Filling recreated email_notification column" do
      counter = 0
      User.select { |u| u.event_settings.any? }.each do |user|
        user.update(email_notification: true)
        counter += 1
      end
      # If the result returned is an Integer, output includes a message
      # about the number of rows in addition to the elapsed time.
      counter
    end
  end

end
