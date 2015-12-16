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
  scope :title, -> title { where('LOWER(title) LIKE ?', "%#{title.downcase}%") }
  scope :chair, -> name { joins(:chair).where("LOWER(name) LIKE ?", "%#{name.downcase}%") }

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

end
