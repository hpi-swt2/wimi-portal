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
  belongs_to :trigger, class_name: 'User'

  validates :type, presence: true
  validates :seclevel, presence: true

  enum seclevel: [ :superadmin, :admin, :representative, :wimi, :hiwi, :user]

  def seclevel_of_user(user)
    if user.admin
      return :admin
    elsif user.is_representative?
      return :representative
    elsif user.is_wimi?
      return :wimi
    elsif user.hiwi?
      return :hiwi
    else
      return :user
    end
  end
end
