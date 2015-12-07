class Trip < ActiveRecord::Base
  belongs_to :user
  has_many :trip_datespans
  accepts_nested_attributes_for :trip_datespans
  validates :name, presence: true
  validates :destination, presence: true
  validates :user, presence: true
end
