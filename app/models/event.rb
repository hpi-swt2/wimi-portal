# == Schema Information
#
# Table name: events
#
# id          :integer      not null, primary key
# trigger     :integer      foreign key
# target      :integer      foreign key
# chair       :integer      foreign key
# seclevel    :integer
# type        :string
class Event < ActiveRecord::Base
  belongs_to :chair
  belongs_to :invitation
  belongs_to :user, foreign_key: 'trigger_id'

  validates :type, presence: true
  validates :seclevel, presence: true

  enum seclevel: [ :superadmin, :admin, :representative, :wimi, :hiwi, :user]

  def seclevel_of_user(user)
    if user.superadmin
      return Event.seclevels[:superadmin]
    elsif user.is_admin?
      return Event.seclevels[:admin]
    elsif user.is_representative?
      return Event.seclevels[:representative]
    elsif user.is_wimi?
      return Event.seclevels[:wimi]
    elsif user.hiwi?
      return Event.seclevels[:hiwi]
    else
      return Event.seclevels[:user]
    end
  end
end
