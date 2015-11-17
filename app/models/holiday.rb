class Holiday < ActiveRecord::Base
  validates_presence_of :user
  belongs_to :user

  def duration
  	(self.end - self.start).to_i/1.day
  end
end
