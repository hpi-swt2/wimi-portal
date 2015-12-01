class Holiday < ActiveRecord::Base
  validates_presence_of :user
  validate :date_has_valid_format?
  validate :start_before_end?
  validate :start_before_today?
  validate :to_far_in_the_future?
  validate :sufficient_leave_left?
  belongs_to :user

  def duration
    start.business_days_until(self.end+1)
  end

  def duration_last_year
    if(start <= Date.new(Date.today.year-1, 12, 31))
      start.business_days_until(Date.new(Date.today.year-1, 12, 31))
    else
      0
    end
  end

  private

  def date_has_valid_format?
  	if (self.start.nil?)
  		errors.add(:start, "must be a valid date!")
  		self.start = Date.today
  	end
  	if (self.end.nil?)
  		errors.add(:end, "must be a valid date!")
      if !(self.start.nil?)
  		  self.end = self.start+1
      else
        self.end = Date.today+1
      end
  	end
  end

  def start_before_end?
  	if !(self.end >= self.start)
  	  errors.add(:start, "must be before #{self.end}")
  	end
  end

  def start_before_today?
  	if !(Date.today <= self.start.to_date)
  		errors.add(:start, "must be after #{Date.today}")
  	end
  end

  def to_far_in_the_future?
    if !(self.end.year < Date.today.year + 2)
      errors.add(:Holiday, "is to far in the future")
    end
  end

  def sufficient_leave_left?
  	#need to assert that user is existent for tests
  	if self.user
      if !(self.user.remaining_leave >= duration)
        errors.add(:not_enough_leave_left!, "" )
      end
  	end
  end
end