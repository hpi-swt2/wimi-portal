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
  validates :chair, presence: true
  validates :seclevel, presence: true

  enum seclevel: [ :superadmin, :admin, :representative, :wimi, :hiwi, :user]

end
