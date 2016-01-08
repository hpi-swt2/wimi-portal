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
  scope :title, -> title { where('LOWER(title) LIKE ?', "%#{title.downcase}%") }
  scope :chair, -> name { joins(:chair).where("LOWER(name) LIKE ?", "%#{name.downcase}%") }

  has_and_belongs_to_many :users
  has_many :publications
  has_many :expenses
  has_many :invitations
  belongs_to :chair

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
    users.select { |u| !u.is_wimi? }
  end

  def wimis
    users.select { |u| u.is_wimi? }
  end

end
