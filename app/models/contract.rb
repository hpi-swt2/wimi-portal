# == Schema Information
#
# Table name: contracts
#
#  id             :integer          not null, primary key
#  start_date     :date
#  end_date       :date
#  chair_id       :integer
#  user_id        :integer
#  hiwi_id        :integer
#  responsible_id :integer
#  flexible       :boolean
#  hours_per_week :integer
#  wage_per_hour  :decimal(5, 2)
#

class Contract < ActiveRecord::Base
  scope :at_date, -> date { where('start_date <= ? AND end_date >= ?', date, date ) }
  scope :contract_with, -> user, chair { where(hiwi: user, chair: chair)}
  scope :for_user_in_month, -> user, month, year { where("hiwi_id = ? AND start_date <= ? AND end_date >= ?",
                                                 user.id, Date.new(year, month, -1), Date.new(year,month,1)) }
  scope :ends_soon, -> { where("end_date >= ? and end_date <= ?",
                        Date.today.beginning_of_month, (Date.today + 2.months).end_of_month).order(end_date: :asc) }

  belongs_to :chair
  belongs_to :hiwi, class_name: 'User'
  belongs_to :responsible, class_name: 'User'
  # If a contract is deleted, delete all of its dependent time sheets
  has_many :time_sheets, -> { order(year: :desc, month: :desc) }, dependent: :destroy
  has_many :events , as: :object, :dependent => :destroy

  validates_presence_of :start_date, :end_date, :chair, :hiwi, :responsible, :wage_per_hour
  validates :wage_per_hour, numericality: {greater_than: 0}
  validates_presence_of :hours_per_week, :unless => :flexible?
  validates :hours_per_week, numericality: {greater_than: 0}, :unless => :flexible?

  # For the purpose of calculating the monthly amount
  # of hours in a contract, the month has 4 weeks
  WEEKS_PER_MONTH = 4

  def time_sheet(month, year)
    d_start = Date.new(year, month).at_beginning_of_month
    d_end = d_start.at_end_of_month
    return nil unless start_date < d_end and end_date > d_start
    # if two contracts in one month, use existing contract's time sheet
    ts = TimeSheet.user(hiwi).month(month).year(year).where(contract: self).first
    ts || TimeSheet.create!(month: month, year: year, contract: self)
  end
  
  def name
    if start_date.year == end_date.year
      formatted_start = I18n.l(start_date, format: :short_month)
    else
      formatted_start = I18n.l(start_date, format: :short_month_year)
    end
    date = "#{formatted_start} - #{I18n.l(end_date, format: :short_month_year)}"
    model = Contract.model_name.human.titleize
    hiwi ? "#{hiwi.last_name} (#{date})" : "#{model} (#{date})"
  end

  def to_s
    name
  end

  def monthly_work_hours
    self.flexible ? nil : self.hours_per_week * WEEKS_PER_MONTH
  end

  def monthly_work_minutes
    self.monthly_work_hours ? self.monthly_work_hours * 60 : self.monthly_work_hours
  end

  def missing_timesheets
    date = Date.today - 1.month
    date = end_date if date > end_date
    contract_dates = ((start_date.at_beginning_of_month)..((date).at_beginning_of_month)).select{|d| d.day == 1}
    valid_dates = time_sheets.select{|ts| ts.status = 'accepted'}.map{|ts| Date.new(ts.year, ts.month)}
    contract_dates.delete_if{|date| valid_dates.include? date }
    contract_dates
  end

  # Return an ordered collection of time sheets of the contract
  # including unsaved instances representing missing time sheets
  def time_sheets_including_missing(upto_date = end_date)
    upto_date = end_date if upto_date > end_date
    upto_date.downto(start_date)
      .map { |d| [d.year, d.month] }.uniq
      .map { |y, m| time_sheets.find_or_initialize_by(year: y, month: m) }
  end
end
