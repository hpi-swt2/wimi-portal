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
  include Rails.application.routes.url_helpers

  has_many :chair_wimis, dependent: :destroy
  has_many :users, through: :chair_wimis
  has_many :projects
  has_many :requests

  validates :name, presence: true

  def wimis
    users.select { |u| u.is_wimi? }
  end

  def hiwis
    projects.collect { |p| p.hiwis }.flatten.uniq
  end

  def admins
    chair_wimis.select { |cw| cw.is_admin? }
  end

  def representative
    chair_wimis.select { |cw| cw.is_representative? }.first
  end

  def add_users(admin_id, representative_id)
    success = false
    admin = User.find_by(id: admin_id)
    representative = User.find_by(id: representative_id)

    if (admin && representative)
      if admin != representative
        unless admin.is_wimi? || representative.is_wimi?
          c1 = ChairWimi.new(admin: true, chair: self, user: admin, application: 'accepted')
          c2 = ChairWimi.new(representative: true, chair: self, user: representative, application: 'accepted')

          if self.save && c1.save && c2.save
            success = true
          end
        end
      else
        unless admin.is_wimi?
          c = ChairWimi.new(admin: true, representative: true, chair: self, user: admin, application: 'accepted')

          if self.save && c.save
            success = true
          end
        end
      end
    end
    return success
  end

  def edit_users(admin_id, representative_id)
    success = false
    admin = User.find_by(id: admin_id)
    representative = User.find_by(id: representative_id)

    if (admin && representative)
      chairwimi1 = ChairWimi.find_by(chair: self, admin: true)
      chairwimi2 = ChairWimi.find_by(chair: self, representative: true)
      if chairwimi1 != nil
        ChairWimi.destroy(chairwimi1.id)
      end
      if chairwimi2 != nil && chairwimi1 != chairwimi2
        ChairWimi.destroy(chairwimi2.id)
      end

      if admin != representative
        unless admin.is_wimi? || representative.is_wimi?
          c1 = ChairWimi.new(admin: true, chair: self, user: admin, application: 'accepted')
          c2 = ChairWimi.new(representative: true, chair: self, user: representative, application: 'accepted')

          if self.save && c1.save && c2.save
            success = true
          end
        end
      else
        unless admin.is_wimi?
          c = ChairWimi.new(admin: true, representative: true, chair: self, user: admin, application: 'accepted')

          if self.save && c.save
            success = true
          end
        end
      end
    end
    return success
  end
end
