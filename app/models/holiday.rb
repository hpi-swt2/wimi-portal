class Holiday < ActiveRecord::Base
  validates_presence_of :user
  validate :start_before_end?
  validate :start_before_today?
  #validate :sufficient_leave_left?
  belongs_to :user

  def duration
  	(self.end - self.start).to_i/1.day
  end

  private

  def start_before_end?
  	#raise self.end.inspect
  	if !(self.end > self.start)
  		errors.add(:start, "must be before #{self.end}")
  	end
  end

  def start_before_today?
  	if !(Date.today <= self.start.to_date)
  		errors.add(:start, "must be after #{Date.today}")
  	end
  end

  def sufficient_leave_left?
  	if !(self.user.remaining_leave_this_year >= duration)
  		errors.add(:Not, 'enough leave left!')
  	end
  end

end