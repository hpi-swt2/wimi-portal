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
  scope :current, -> user { user(user).year(Date.today.year).month(Date.today.month)}
  scope :accepted, -> { where(status: 'accepted')}

  belongs_to :contract
  has_one :user, through: :contract, source: :hiwi
  enum status: [:pending, :accepted, :rejected, :created, :closed]
  # When a time sheet is destroyed, also destroy all of the connected work days
  has_many :work_days, :inverse_of => :time_sheet, dependent: :destroy
  has_many :events, as: :object, :dependent => :destroy
  has_many :projects, through: :work_days
  
  validates :month, numericality: {greater_than: 0}
  validates :year, numericality: {greater_than: 0}

  validate :unique_date, :contract_date_fits

  accepts_nested_attributes_for :work_days, reject_if: :reject_work_day, :allow_destroy => true

  after_initialize :set_default_status, :if => :new_record?

  def name
    I18n.l first_day, format: :short_month_year
  end
  
  def hand_in
    # Update also saves, returns false if saving failed
    # http://apidock.com/rails/ActiveRecord/Persistence/update
    success = self.update(
      status: 'pending',
      handed_in: true,
      hand_in_date: Date.today
    )
    if success
      Event.add(:time_sheet_hand_in, self.user, self, self.contract.responsible)
    end
    return success
  end

  def accept_as(wimi)
    success = self.update(
      status: 'accepted',
      last_modified: Date.today,
      signer: wimi.id,
      representative_signature: wimi.signature,
      representative_signed_at: Date.today())
    if success
      Event.add(:time_sheet_accept, wimi, self, self.user)
    end
    return success
  end

  def reject_as(wimi)
    success = self.update(
      status: 'rejected',
      handed_in: false,
      last_modified: Date.today(),
      signer: wimi.id,
      user_signature: nil,
      signed: false,
      user_signed_at: nil)
    if success
      Event.add(:time_sheet_decline, wimi, self, self.user)
    end
    return success
  end

  def reject_work_day(attributes)
    exists = attributes['id'].present?
    empty = attributes.slice(:start_time, :end_time).values.all?(&:blank?)
    zero_values = attributes.slice(:start_time, :end_time).values.all? {|time| time == '0'}
    attributes.merge!({:_destroy => 1}) if exists and (empty or zero_values) # destroy empty work day
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
    format('%d:%02d', hours, minutes)
  end

  def monthly_work_minutes
    self.contract.monthly_work_minutes
  end

  def monthly_work_minutes_formatted
    if self.monthly_work_minutes
      minutes = self.monthly_work_minutes % 60
      hours = (self.monthly_work_minutes - minutes) / 60
      format('%d:%02d', hours, minutes)
    else
      self.monthly_work_minutes
    end
  end

  def percentage_hours_worked
    if self.monthly_work_minutes
      (self.sum_minutes / self.monthly_work_minutes.to_f) * 100
    else
      self.monthly_work_minutes
    end
  end

  def first_day
    Date.new(year, month, 1)
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

  # Used by controllers/documents_controller.rb to
  # set the name of exported PDFs of time sheets.
  # Is always in German, as is the exported document
  def pdf_export_name
    last_name = self.user.last_name
    date = I18n.l(self.first_day, format: "%m %Y")
    return "Arbeitszeitnachweis #{last_name} #{date}"
  end

  def name
    I18n.l(Date.new(year, month, 1), format: :short_month_year)
  end

  def work_time_per_project
    wt = {}
    self.work_days.each do |wd|
      if wt[wd.project.name]
        wt[wd.project.name] += wd.duration_in_minutes
      else
        wt[wd.project.name] = wd.duration_in_minutes
      end
    end
    return wt
  end

  def projects_worked_on
    projects = Set.new
    self.work_days.each do |wd|
      projects << wd.project
    end
    return projects.to_a
  end
  
  private

  # Initialize the TimeSheet to status "created", if not other status is set.
  # As "pending" is first in the enum definition, it is normally the standard
  def set_default_status
    self.status = :created if TimeSheet.statuses.keys.first == self.status
  end

  def unique_date
    ts = TimeSheet.user(self.user).where(contract_id: self.contract_id).month(self.month).year(self.year)
    if ts.any? and ts.first.id != self.id
      errors.add(:month, I18n.t('activerecord.errors.models.time_sheet.month.already_exists'))
    end
  end

  def contract_date_fits
    if last_day < self.contract.start_date || first_day > self.contract.end_date
      errors.add(:month, I18n.t('activerecord.errors.models.time_sheet.month.no_contract'))
    end
  end
end
