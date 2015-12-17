class EventAdminRightsChanged < ActiveRecord::Base
  belongs_to :admin, class_name: User
  belongs_to :user

  validates :admin, presence: true
  validates :user, presence: true
end
