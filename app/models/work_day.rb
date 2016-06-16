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
  
  scope :user, -> user { where(user: user) }
  scope :project, -> project { where(project: project) }
  scope :date, -> date  { where(date: date) }
  scope :month, -> month, year {
    date = Date.new(year, month)
    where(date: date.beginning_of_month..date.end_of_month)
  }
  scope :contract, -> contract { where(date: contract.start_date..contract.end_date).user(contract.hiwi) }
  scope :time_sheet, -> time_sheet { contract(time_sheet.contract).month(time_sheet.month, time_sheet.year) }
  
  belongs_to :user
  belongs_to :project

  validates :user_id, presence: true, numericality: true
#  validates :project_id, presence: true, numericality: true
  validates :date, presence: true
  validates :start_time, presence: true
  validates :break, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :end_time, presence: true
  validate :no_overlap
  validates_time :end_time, after: :start_time
  validates :duration, numericality: {greater_than: 0}

  def to_s
    model = I18n.t('activerecord.models.work_day.one', default: WorkDay.to_s)
    "#{model}: #{I18n.l(date)}"
  end

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

  def duration_hours_minutes
    work_time = duration_in_minutes
    minutes = work_time % 60
    hours = (work_time - minutes) / 60
    format("%d:%02d", hours, minutes)
  end
  
  def time_sheet
    user.time_sheets_for(date).first
  end
end
