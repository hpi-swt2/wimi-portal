class TravelExpenseReport < ActiveRecord::Base
  belongs_to :trip
  has_many :ter_items, :dependent => :destroy_all
end
