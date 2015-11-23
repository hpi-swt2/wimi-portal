class WorkDay < ActiveRecord::Base
	belongs_to :work_month

	def duration
        return (end_time - start_time) / 60 - brake
    end
end
