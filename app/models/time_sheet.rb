# == Schema Information
#
# Table name: time_sheets
#
#  id                       :integer          not null, primary key
#  month                    :integer
#  year                     :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  handed_in                :boolean          default(FALSE)
#  rejection_message        :text             default("")
#  signed                   :boolean          default(FALSE)
#  last_modified            :date
#  status                   :integer          default(0)
#  signer                   :integer
#  wimi_signed              :boolean          default(FALSE)
#  hand_in_date             :date
#  user_signature           :text
#  representative_signature :text
#  user_signed_at           :date
#  representative_signed_at :date
#  contract_id              :integer          not null
#

class TimeSheet < ActiveRecord::Base

  scope :month, -> month { where(month: month) }
  scope :year, -> year { where(year: year) }
  scope :recent, -> { where('12 * year + month > ?', 12*Date.today.year + Date.today.month - 3) }
  scope :user, -> user { joins(:contract).where('contracts.hiwi_id' => user.id) }

  belongs_to :contract
  has_one :user, through: :contract, source: :hiwi
  enum status: [:pending, :accepted, :rejected, :created]
  has_many :work_days, :inverse_of => :time_sheet
  
  validates :month, numericality: {greater_than: 0}
  validates :year, numericality: {greater_than: 0}

  accepts_nested_attributes_for :work_days, reject_if: :reject_work_day, :allow_destroy => true

  after_initialize :set_default_status, :if => :new_record?

  def reject_work_day(attributes)
    exists = attributes['id'].present?
    empty = attributes.slice(:start_time, :end_time).values.all?(&:blank?)
    attributes.merge!({:_destroy => 1}) if exists and empty # destroy empty tour
    return (!exists and empty) # reject empty attributes
  end

  def sum_hours
    sum_minutes / 60
  end

  def sum_minutes
    sum = 0
    work_days.each do |w|
      sum += w.duration_in_minutes
    end
    sum
  end

  def sum_minutes_formatted
    work_time = sum_minutes
    minutes = work_time % 60
    hours = (work_time - minutes) / 60
    format("%d:%02d", hours, minutes)
  end

  def first_day
    Date.new(year,month,1)
  end

  def last_day
    first_day.end_of_month
  end

  def next_date
    if month == 12
      return {month: 1, year: year + 1}
    else
      return {month: month + 1, year: year}
    end
  end

  def previous_date
    if month == 1
      return {month: 12, year: year - 1}
    else
      return {month: month - 1, year: year}
    end
  end

  def containsDate(date)
    if first_day <= date && last_day >= date
      return true
    end
    return false
  end

  def has_comments?
    work_days.each do |w|
      if w.notes != nil && !w.notes.empty?
        return true
      end
    end
    return false
  end

  def generate_work_days
    (first_day..last_day).each do |day|
      work_days.new(date: day)
    end
  end

  def generate_missing_work_days
    (first_day..last_day).each do |day|
      exists = false
      self.work_days.each do |work_day|
        if work_day.date == day
          exists = true
        end
      end
      if !exists
        self.work_days.build(date: day)
      end
    end
   # self.work_days.sort! { |a,b| a.date <=> b.date }
  end

  private

  # Initialize the TimeSheet to status "created".
  # As "pending" is first in the enum definition, it is the standard
  def set_default_status
    self.status = "created"
  end

end
