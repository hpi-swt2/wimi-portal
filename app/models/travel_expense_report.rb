class TravelExpenseReport < ActiveRecord::Base
  belongs_to :trip
  has_many :ter_items, :dependent => :destroy

  validates :name, presence: true
  validates :advance , numericality: true
end
