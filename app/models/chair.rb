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

  def admin_users
    admins.collect(&:user)
  end

  def representative
    chair_wimis.find(&:is_representative?)
  end

  def create_allrequests(types, statuses)
    @allrequests = []

    users.each do |user|
      add_requests(I18n.t('chair.requests.holiday_request'), user.holidays, statuses) if types.include? 'holidays'
      add_requests(I18n.t('chair.requests.expense_request'), user.expenses, statuses) if types.include? 'expenses'
      add_requests(I18n.t('chair.requests.trip_request'), user.trips, statuses) if types.include? 'trips'
    end

    return @allrequests.sort_by { |v| v[:handed_in] }.reverse
  end

  def check_correct_user(id)
    user = User.find_by(id: id)
    if !user || user.is_superadmin?
      return false
    elsif user.chair_wimi && user.chair_wimi.application == 'accepted'
      if user.chair_wimi.chair != self
        return false
      end
    end
    return true
  end

  def set_initial_users(admins_param, representative_param)
    success = true

    admin_array = []
    admins_param.try(:each) do |id|
      success = check_correct_user(id[1])
      admin_array << User.find_by(id: id[1])
    end
    success = check_correct_user(representative_param) if representative_param

    if success
      set_admins(admin_array)
      set_representative(User.find_by(id: representative_param))
      return true
    else
      return false
    end
  end

  def set_admins(admin_array)
    admins.each do |admin|
      admin.admin = false
      admin.save
    end

    admin_array.try(:each) do |admin|
      chair_wimi = ChairWimi.find_by(user: admin)
      if chair_wimi
          admin.chair_wimi.destroy
      end
      ChairWimi.create(chair: self, user: admin, admin: true, application: 'accepted')
    end
  end

  def set_representative(new_representative)
    former = representative
    if former
      former.representative = false
      former.save
    end

    if new_representative
      chair_wimi = ChairWimi.find_by(user: new_representative)
      if chair_wimi
        if chair_wimi.application == 'pending'
          chair_wimi.destroy
        else
          chair_wimi.representative = true
          chair_wimi.save
        end
      else
        ChairWimi.create(chair: self, user: new_representative, representative: true, application: 'accepted')
      end
    end
  end

  def add_requests(type, array, statuses)
    array.each do |r|
      if statuses.include? r.status
        @allrequests << {name: r.user.name, type: type, handed_in: r.created_at, status: r.status, action: r}
      end
    end
  end
end
