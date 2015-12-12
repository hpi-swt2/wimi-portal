# == Schema Information
#
# Table name: chairs
#
#  id           :integer          not null, primary key
#  name         :string
#  abbreviation :string
#  description  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Chair < ActiveRecord::Base
  has_many :chair_wimis, dependent: :destroy
  has_many :users, through: :chair_wimis
  has_many :projects

  validates :name, presence: true

  def wimis
    users.select { |u| u.is_wimi? }
  end

  def hiwis
    projects.collect { |p| p.hiwis }.flatten.uniq
  end

  def add_users(admin_id, representative_id)
    success = false
    admin = User.find_by(id: admin_id)
    representative = User.find_by(id: representative_id)

    if (admin && representative) && admin != representative
      unless admin.is_wimi? || representative.is_wimi?
        c1 = ChairWimi.new(admin: true, chair: self, user: admin, application: 'accepted')
        c2 = ChairWimi.new(representative: true, chair: self, user: representative, application: 'accepted')

        if self.save && c1.save && c2.save
          success = true
        end
      end
    end
    return success
  end
end
