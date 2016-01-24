# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  description    :string           default("")
#  public         :boolean          default(TRUE)
#  status         :boolean          default(TRUE)
#  chair_id       :integer
#  project_leader :string           default("")
#

class Project < ActiveRecord::Base
  scope :title, -> title { where('LOWER(title) LIKE ?', "%#{title.downcase}%") }
  scope :chair, -> name { joins(:chair).where('LOWER(name) LIKE ?', "%#{name.downcase}%") }

  has_and_belongs_to_many :users
  has_many :project_applications, dependent: :destroy
  has_many :invitations
  belongs_to :chair

  accepts_nested_attributes_for :invitations, allow_destroy: true

  validates :title, presence: true

  def invite_user(user)
    user.invitations << Invitation.create(user: user, project: self)
  end

  def add_user(user)
    users << user
  end

  def destroy_invitation(user)
    Invitation.find_by(user: user, project: self).destroy!
  end

  def hiwis
    users.select(&:is_hiwi?)
  end

  def wimis
    users.select(&:is_wimi?)
  end

  def remove_user(user)
    users.delete(user)
    if project_applications.include?(ProjectApplication.find_by_user_id user.id)
      project_applications.delete(ProjectApplication.find_by_user_id user.id)
    end
  end
end
