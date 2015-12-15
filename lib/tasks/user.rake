namespace :user do
  task prepare_leave_for_new_year: :environment do
  	users = User.all
  	users.each do |user|
      user.update_attribute(:remaining_leave_last_year, user.remaining_leave)
      user.update_attribute(:remaining_leave, 28)
    end
  end
end
