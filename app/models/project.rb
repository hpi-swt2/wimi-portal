# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string           default("")
#  public      :boolean          default(FALSE)
#  active      :boolean          default(TRUE)
#  chair_id    :integer
#

class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :publications
  has_many :expenses
  belongs_to :chair

  def add_user(user)
    users << user
    user.notifications << Notification.create(message: I18n.t('project.was_added_to_project', title: title,  default: "Du wurdest zum Projekt '#{title}' hinzugefügt."))
  end

  validates :title, presence: true

  def hiwis
    users.select { |u| !u.is_wimi? }
  end

  def wimis
    users.select { |u| u.is_wimi? }
  end

  def remove_user(user)
    users.delete(user)
    user.notifications << Notification.create(message: I18n.t('project.was_signed_out_project', title: title,  default: "'#{user}' was signed out of the project."))
  end

end
