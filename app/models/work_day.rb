class WorkDay < ActiveRecord::Base
	belongs_to :user

	validates :brake, numericality: true

	def duration
        return (end_time - start_time).to_i / 60 - brake
    end
end
