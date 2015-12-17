class TravelExpenseReport < ActiveRecord::Base
  belongs_to :user
  has_many :travel_expense_report_items
  accepts_nested_attributes_for :travel_expense_report_items, reject_if: lambda {|attributes| attributes['date(1i)'].blank? or attributes['date(3i)'].blank? or attributes['date(2i)'].blank?}
  
  validates :location_from, presence: true
  validates :location_to, presence: true
  validates :general_advance, numericality: {greater_than_or_equal_to: 0}
  validate 'start_before_end_date'


  def first_name
    self.user.first_name
  end

  def last_name
    self.user.last_name
  end

  def get_signature
    self.user.signature
  end

  def start_before_end_date
    if date_start > date_end
      errors.add(:date_start, "can't be after end date")
    end
  end
end
