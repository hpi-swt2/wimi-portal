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

  
  belongs_to :time_sheet

  validates :time_sheet, presence: true
  validates :date, presence: true
  validates :break, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates_time :end_time, after: :start_time
  validates :duration, numericality: {greater_than: 0}

  before_validation :default_values

  def to_s
    model = I18n.t('activerecord.models.work_day.one', default: WorkDay.to_s)
    "#{model}: #{I18n.l(date)}"
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

  def duration_hours_minutes
    work_time = duration_in_minutes
    minutes = work_time % 60
    hours = (work_time - minutes) / 60
    format("%d:%02d", hours, minutes)
  end
end