class TravelExpenseReport < ActiveRecord::Base
  has_many :ter_items
  belongs_to :trip
end
