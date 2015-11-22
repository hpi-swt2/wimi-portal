class WorkMonth < ActiveRecord::Base
	belongs_to :user
	has_many :work_days

	def full_name
		return name + ' ' + year.to_s
	end
end
