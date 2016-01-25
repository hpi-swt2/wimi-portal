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
  has_many :events

  validates :name, presence: true

  def wimis
    users.select(&:is_wimi?)
  end

  def hiwis
    projects.collect(&:hiwis).flatten.uniq
  end

  def admins
    chair_wimis.select(&:is_admin?)
  end

  def representative
    chair_wimis.find(&:is_representative?)
  end

  def add_users(admin_id, representative_id)
    success = false
    admin = User.find_by(id: admin_id)
    representative = User.find_by(id: representative_id)

    if admin && representative && !(admin.is_superadmin? || representative.is_superadmin?)
      if admin != representative
        unless admin.is_wimi? || representative.is_wimi?
          c1 = ChairWimi.new(admin: true, chair: self, user: admin, application: 'accepted')
          c2 = ChairWimi.new(representative: true, chair: self, user: representative, application: 'accepted')

          if save && c1.save && c2.save
            success = true
          end
        end
        if adminApp = ChairWimi.find_by(user: admin, application: 'pending')
          adminApp.destroy
        end
        if repApp = ChairWimi.find_by(user: representative, application: 'pending')
          repApp.destroy
        end
      else
        unless admin.is_wimi?
          c = ChairWimi.new(admin: true, representative: true, chair: self, user: admin, application: 'accepted')

          if save && c.save
            success = true
          end
        end
        if app = ChairWimi.find_by(user: admin, application: 'pending')
          app.destroy
        end
      end
    end
    return success
  end

  def edit_users(admin_id, representative_id)
    success = false
    admin = User.find_by(id: admin_id)
    representative = User.find_by(id: representative_id)

    if admin && representative && !(admin.is_superadmin? || representative.is_superadmin?)
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

          if save && c1.save && c2.save
            success = true
          end
        end
        if adminApp = ChairWimi.find_by(user: admin, application: 'pending')
          adminApp.destroy
        end
        if repApp = ChairWimi.find_by(user: representative, application: 'pending')
          repApp.destroy
        end
      else
        unless admin.is_wimi?
          c = ChairWimi.new(admin: true, representative: true, chair: self, user: admin, application: 'accepted')

          if save && c.save
            success = true
          end
        end
        if app = ChairWimi.find_by(user: admin, application: 'pending')
          app.destroy
        end
      end
    end
    return success
  end

  def create_allrequests(types, statuses)
    @allrequests = []

    users.each do |user|
      add_requests(I18n.t('chair.requests.holiday_request'), user.holidays, statuses) if types.include? 'holidays'
      add_requests(I18n.t('chair.requests.expense_request'), user.travel_expense_reports, statuses) if types.include? 'expenses'
      add_requests(I18n.t('chair.requests.trip_request'), user.trips, statuses) if types.include? 'trips'
    end

    return @allrequests.sort_by { |v| v[:handed_in] }.reverse
  end

  def add_requests(type, array, statuses)
    array.each do |r|
      if statuses.include? r.status
        @allrequests << {name: r.user.name, type: type, handed_in: r.created_at, status: r.status, action: r}
      end
    end
  end
end
