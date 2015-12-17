class TripDatespan < ActiveRecord::Base
  belongs_to :trip

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :days_abroad, presence: true, numericality: true
  validate :start_before_end_date, :days_abroad_leq_to_total_days

  def total_days
    (end_date - start_date).to_i
  end

  private

  def days_abroad_leq_to_total_days
    if(days_abroad > total_days)
      errors.add(:days_abroad, "can't be larger than total days")
    end
  end


  def start_before_end_date
    if(end_date < start_date)
      errors.add(:start_date, "can't be before end_date")
    end
  end

end
