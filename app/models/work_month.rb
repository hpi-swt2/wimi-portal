class WorkMonth < ActiveRecord::Base
	belongs_to :user
	has_many :work_days
end
