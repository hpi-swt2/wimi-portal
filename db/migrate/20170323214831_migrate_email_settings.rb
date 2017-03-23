class MigrateEmailSettings < ActiveRecord::Migration


	all_events = Event.types.collect { |type, val| val }

	User.all.each do |user|
		if user.email_notification
			user.update(event_settings: all_events)
		end
	end

  def change
  	remove_column :users, :email_notification, :boolean
  end
end
