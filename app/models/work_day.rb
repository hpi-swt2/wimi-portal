# == Schema Information
#
# Table name: work_days
#
#  id         :integer          not null, primary key
#  date       :date
#  start_time :time
#  break      :integer
#  end_time   :time
#  attendance :string
#  notes      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  project_id :integer
#

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
