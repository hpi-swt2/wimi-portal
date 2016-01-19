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
  validates :project_id, presence: true, numericality: true
  validates :date, presence: true
  validates :start_time, presence: true
  validates :break, presence: true, numericality: true
  validates :end_time, presence: true
  validate :project_id_exists
  validates_time :end_time, after: :start_time 
  validates :duration, numericality: {greater_than: 0}
  
  def duration
    unless end_time.blank? || start_time.blank? || self.break.blank?
      ((end_time - start_time).to_i / 60 - self.break) / 60.0
    end
  end

  def project_id_exists
    return false if Project.find_by_id(project_id).nil?
  end

  def self.all_for(year, month, project, user)
    date = Date.new(year, month)
    month_start = date.beginning_of_month
    month_end = date.end_of_month
    if project.nil?
      return WorkDay.where(date: month_start..month_end, user: user)
    else
      return WorkDay.where(date: month_start..month_end, user: user, project_id: project)
    end
  end
end
