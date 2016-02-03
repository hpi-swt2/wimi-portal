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
  validates :chair, presence: true

  def invite_user(user, sender)
    if user && !user.is_superadmin?
      inv = Invitation.create(user: user, project: self, sender: sender)
      ActiveSupport::Notifications.instrument('event', {trigger: inv.id, target: user.id, seclevel: :hiwi, type: 'EventProjectInvitation'})
      user.invitations << inv
      return true
    else
      return false
    end
  end

  def add_user(user)
    if user && !user.is_superadmin?
      users << user
      return true
    else
      return false
    end
  end

  def destroy_invitation(user)
    inv = Invitation.find_by(user: user, project: self)
    Event.find_by(trigger: inv.id, target_id: user.id).destroy!
    inv.destroy!
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

  def hiwi_working_hours_for(year, month)
    sum_working_hours = 0
    hiwis.each do |hiwi|
      sum_working_hours += TimeSheet.time_sheet_for(year, month, self, hiwi).sum_hours
    end
    return sum_working_hours
  end

  def self.working_hours_data(year, month)
    data = []
    Project.find_each do |project|
      entry = {y: project.hiwi_working_hours_for(year, month), name: project.title}
      data.push(entry)
    end
    return data.to_json
  end
end
