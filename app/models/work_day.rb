class WorkDay < ActiveRecord::Base
	belongs_to :user
	belongs_to :project

	validates :user_id, presence: true, numericality: true
	validates :date, presence: true
	validates :start_time, presence: true
	validates :break, presence: true, numericality: true
	validates :end_time, presence: true

	def duration
        return (end_time - start_time).to_i / 60 - self.break
    end
end
