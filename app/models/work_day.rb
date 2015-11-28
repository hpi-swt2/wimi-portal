class WorkDay < ActiveRecord::Base
	belongs_to :user

	validates :break, numericality: true

	def duration
        return (end_time - start_time).to_i / 60 - self.break
    end
end
