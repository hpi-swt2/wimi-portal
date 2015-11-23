class WorkDay < ActiveRecord::Base
	belongs_to :work_month

	validates :brake, numericality: true

	def duration
        return (end_time - start_time) / 60 - brake
    end
end
