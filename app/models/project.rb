# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :publications
  has_many :expenses

  def add_user(user_email)
    user = User.find_by_email user_email
    users << user
    user.notifications << Notification.create(message: "Du wurdest zum Projekt '#{title}' hinzugefügt.")
  end
end
