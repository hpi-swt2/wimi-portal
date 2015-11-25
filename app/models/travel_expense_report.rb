class TravelExpenseReport < ActiveRecord::Base
  belongs_to :trip
  has_many :ter_items, :dependent => :destroy
  accepts_nested_attributes_for :ter_items

  validates :name, presence: true
  validates :advance , numericality: true
end
