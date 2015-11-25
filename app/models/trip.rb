class Trip < ActiveRecord::Base
  has_many :travel_expense_reports, :dependent => :destroy_all
  validates :name, presence: true
  validates :destination, presence: true
  validate 'duration_greater_than_zero'

  def duration
    (end_date - start_date).to_i
  end

  def duration_greater_than_zero
    if duration <= 0
      errors.add(:duration, "can't be less or equal to zero")
    end
  end
end
