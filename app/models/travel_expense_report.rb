class TravelExpenseReport < ActiveRecord::Base
  belongs_to :user
  has_many :travel_expense_report_items
  accepts_nested_attributes_for :travel_expense_report_items
end
