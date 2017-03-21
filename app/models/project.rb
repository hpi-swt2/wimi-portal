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
  belongs_to :chair
  has_many :work_days
  has_many :events , as: :object, dependent: :destroy

  validates :title, presence: true
  validates :chair, presence: true

  before_destroy :check_for_workdays

  def invite_user(user, sender)
    if user && !user.is_superadmin? # <-- what is the superadmin doing here?
      inv = Invitation.create(user: user, project: self, sender: sender)
      user.invitations << inv
      Event.add(:project_join, sender, self, user)
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

  def destroy_invitations
    invitation = Invitation.where(project: self)
    invitation.each do |inv|
      inv.destroy!
    end
  end

  def destroy_invitation(user)
    inv = Invitation.find_by(user: user, project: self)
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
  end

  def hiwi_working_hours_for(year, month)
    work_days.month(month, year).to_a.sum(&:duration)
  end

  def name
    self.title
  end

  private

  # a project can only be deleted when noone has entered any workdays for it yet.
  def check_for_workdays
    if not work_days.empty?
      errors.add(:base, :cannot_delete)
      return false
    end
  end
end
