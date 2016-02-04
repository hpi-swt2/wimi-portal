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
  validate :no_overlap
  validates_time :end_time, after: :start_time
  validates :duration, numericality: {greater_than: 0}

  def overlaps(other)
    other_date = other.end_time
    start_time_same_date = Time.new(other_date.year, other_date.month, other_date.day, start_time.hour, start_time.min, start_time.sec)
    end_time_same_date = Time.new(other_date.year, other_date.month, other_date.day, end_time.hour, end_time.min, end_time.sec)
    return other.id != id && (not (start_time_same_date >= other.end_time || end_time_same_date <= other.start_time))
  end

  def no_overlap
    if start_time.present? && end_time.present? && date.present? && user_id.present?
      other_work_days = WorkDay.where(date: date, user_id: user_id)
      if other_work_days.any? {|day| self.overlaps(day)}
        errors.add(:end_time, 'overlaps with another work day')
      end
    end
  end

  def duration
    unless end_time.blank? || start_time.blank? || self.break.blank?
      duration_in_minutes.to_f / 60
    end
  end

  def duration_in_minutes
    unless end_time.blank? || start_time.blank? || self.break.blank?
      (end_time - start_time).to_i / 60 - self.break
    end
  end

  def project_id_exists
    return false if Project.find_by_id(project_id).nil?
  end

  def self.all_for(year, month, project, user)
    # year and month are 0 when they are not passed to the controller (nil.to_i = 0)
    if year == 0 || month == 0
      return WorkDay.where(user: user, project_id: project)
    else
      date = Date.new(year, month)
      month_start = date.beginning_of_month
      month_end = date.end_of_month
      return WorkDay.where(date: month_start..month_end, user: user, project_id: project)
    end
  end

  def duration_hours_minutes
    work_time = duration_in_minutes
    minutes = work_time % 60
    hours = (work_time - minutes) / 60
    format("%d:%02d", hours, minutes)
  end
end
