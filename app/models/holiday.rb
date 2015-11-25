# == Schema Information
#
# Table name: holidays
#
#  id         :integer          not null, primary key
#  status     :string
#  start      :datetime
#  end        :datetime
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Holiday < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user
  validates_datetime :start
  validates_datetime :end
  validates_datetime :start, :on_or_after => :today
  validates_datetime :end, :after => :start
  validate :too_far_in_the_future?
  validate :sufficient_leave_left?

  def sum_duration
    duration_this_year + duration_next_year
  end

  def end_of_this_year
    Date.today.change(day: 31, month: 12)
  end

  def start_of_next_year
    Date.today.change(year: Date.today.year + 1, day: 1, month: 1)
  end

  def duration_this_year
    if (self.start.year <= (Date.today.year))
      if (self.end.year <= (Date.today.year))
        (self.end - self.start).to_i/1.day + 1
      else
        (end_of_this_year - self.start.to_date).to_i + 1
      end
    else
      0
    end
  end

  def duration_next_year
    if (self.start.year <= (Date.today.year))
      if (self.end.year <= (Date.today.year))
        0
      else
      (self.end.to_date - start_of_next_year).to_i + 1
      end
    else
      (self.end - self.start).to_i/1.day + 1
    end
  end

  private

  def too_far_in_the_future?
    unless self.end.year < Date.today.year + 2
      errors.add(:Holiday, "is too far in the future")
    end
  end

  def sufficient_leave_left?
    if self.user
      unless self.user.remaining_leave_this_year >= duration_this_year
        errors.add(:Not, "enough leave for this year left!")
      end
      unless self.user.remaining_leave_next_year >= duration_next_year
        errors.add(:Not, "enough leave for next year left")
      end
    end
  end
end
