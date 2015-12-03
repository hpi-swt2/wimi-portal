class TravelExpenseReport < ActiveRecord::Base
  belongs_to :user
  has_many :travel_expense_report_items
  accepts_nested_attributes_for :travel_expense_report_items

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :general_advance, numericality: true
  validate 'start_before_end_date'


  def general_advance_positive
    if general_advance < 0
      errors.add(:general_advance, "can't be negative")
    end
  end

  def start_before_end_date
    if date_start > date_end
      errors.add(:date_start, "can't be after end date")
    end
  end
end