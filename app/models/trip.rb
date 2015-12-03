class Trip < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true
  validates :destination, presence: true
  validates :user, presence: true
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
