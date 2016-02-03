# == Schema Information
#
# Table name: time_sheets
#
#  id                    :integer          not null, primary key
#  month                 :integer
#  year                  :integer
#  salary                :integer
#  salary_is_per_month   :boolean
#  workload              :integer
#  workload_is_per_month :boolean
#  user_id               :integer
#  project_id            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  handed_in             :boolean          default(FALSE)
#  rejection_message     :text             default("")
#  signed                :boolean          default(FALSE)
#  last_modified         :date
#  status                :integer          default(0)
#  signer                :integer
#  wimi_signed           :boolean          default(FALSE)
#  hand_in_date          :date
#

class TimeSheet < ActiveRecord::Base

  DEFAULT_SALARY = 10.00
  DEFAULT_WORKLOAD = 9

  belongs_to :user
  belongs_to :project
  enum status: [:pending, :accepted, :rejected]

  validates_numericality_of :salary, greater_than_or_equal_to: 0
  validates :salary_is_per_month, inclusion: {in: [true, false]}
  validates_numericality_of :workload, greater_than_or_equal_to: 0
  validates :workload_is_per_month, inclusion: {in: [true, false]}

  def sum_hours
    hour_counter = 0
    month_year_range = Date.new(year, month, 1)..Date.new(year, month, Time.days_in_month(month, year))
    WorkDay.where(date: month_year_range, project: project_id, user: user_id).each do |day|
      hour_counter += day.duration
    end
    return hour_counter
  end

  def self.time_sheet_for(year, month, project, user)
    if project.nil?
      return nil
    else
      sheets = TimeSheet.where(year: year, month: month, project: project, user: user)
      if sheets.empty?
        return create_new_time_sheet(year, month, project, user)
      else
        return sheets.first
      end
    end
  end

  def self.create_new_time_sheet(year, month, project, user)
    TimeSheet.create(year: year, month: month, project: project, user: user, workload_is_per_month: false, salary_is_per_month: false, salary: DEFAULT_SALARY, workload: DEFAULT_WORKLOAD)
  end

  def work_days
    WorkDay.all_for(year, month, project, user)
  end

  def sum_minutes
    sum_hours * 60
  end

  def sum_minutes_formatted
    work_time = sum_minutes
    minutes = work_time % 60
    hours = (work_time - minutes) / 60
    format("%d:%02d", hours, minutes)
  end
end
