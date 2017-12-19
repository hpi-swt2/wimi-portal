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
  scope :month, -> month,year { where('start_date <= ? AND end_date >= ?', Date.new(year,month).at_end_of_month, Date.new(year,month).at_beginning_of_month)}
  scope :contract_with, -> user, chair { where(hiwi: user, chair: chair)}
  scope :for_user_in_month, -> user, month, year { where('hiwi_id = ? AND start_date <= ? AND end_date >= ?',
                                                 user.id, Date.new(year, month, -1), Date.new(year, month, 1)) }
  scope :ends_soon, -> { where('end_date >= ? and end_date <= ?',
                        Date.today.beginning_of_month, (Date.today + 2.months).end_of_month).order(end_date: :asc) }
  scope :year, -> year { where('start_date <= ? AND end_date >= ?', Date.new(year,12,31), Date.new(year,1,1))}

  belongs_to :chair
  belongs_to :hiwi, class_name: 'User'
  belongs_to :responsible, class_name: 'User'
  # If a contract is deleted, delete all of its dependent time sheets
  has_many :time_sheets, -> { order(year: :desc, month: :desc) }, dependent: :destroy
  has_many :events, as: :object, :dependent => :destroy

  validates_presence_of :start_date, :end_date, :chair, :hiwi, :responsible, :wage_per_hour
  validates :wage_per_hour, numericality: {greater_than: 0}
  validates_presence_of :hours_per_week, :unless => :flexible?
  validates :hours_per_week, numericality: {greater_than: 0}, :unless => :flexible?

  # For the purpose of calculating the monthly amount
  # of hours in a contract, the month has 4 weeks
  WEEKS_PER_MONTH = 4

  def time_sheet(month, year)
    ts = peek_time_sheet(month, year)
    return nil unless ts.present?
    ts.save! if ts.new_record?
    ts
  end

  def valid_in(date)
    return (start_date <= date.at_end_of_month) && (end_date >= date.at_beginning_of_month)
  end

  def peek_time_sheet(month, year)
    d_start = Date.new(year, month).at_beginning_of_month
    d_end = d_start.at_end_of_month
    return nil unless start_date <= d_end and end_date >= d_start
    # if two contracts in one month, use existing contract's time sheet
    ts = TimeSheet.user(hiwi).month(month).year(year).where(contract: self).first
    ts || TimeSheet.new(month: month, year: year, contract: self)
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

  def salary_for_month(month, year)
    if self.flexible
      ts = self.time_sheets.year(year).month(month)
      if ts
        return (ts.first.sum_minutes * self.wage_per_hour / 60).round(2)
      else
        return 0
      end
    else
      return self.monthly_salary
    end
  end

  def salaries_for_year(year)
    (1..12).collect do |month|
      self.salary_for_month(month, year)
    end
  end

  def monthly_salary
    if self.flexible
      return 0
    else
      return self.hours_per_week * self.wage_per_hour * 4
    end
  end

  def projects_worked_on_in(month, year)
    ts = self.time_sheets.year(year).month(month).accepted().first
    projects = []
    if ts
      projects = ts.projects_worked_on.collect {|p| p.name}
    end
    if projects.empty? and month < Date.today.month
      projects << 'Not categorized'
    end
    return projects
  end
  
  def work_time_per_project(year)
    work_time_pp = {}
    if self.start_date.year > year
      return work_time_pp
    end
    start_month = year == self.start_date.year ? self.start_date.month : 1
    end_month = year == self.end_date.year ? self.end_date.month : 12
    (start_month..end_month).each do |month|
      ts = self.time_sheets.year(year).month(month).accepted().first
      wt = {}
      projects = self.projects_worked_on_in(month,year)
      if ts 
        wt = ts.work_time_per_project
      end
      projects.each do |projectname|
        if not work_time_pp.include? projectname
          work_time_pp[projectname] = Array.new(12,0)
        end
        if flexible
          work_time_pp[projectname][month-1] += ts ? wt[projectname] : 0
        else
          work_time_pp[projectname][month-1] += (self.hours_per_week * WEEKS_PER_MONTH / projects.length * 60).round(2)
        end
      end
    end
    return work_time_pp
  end

  def reporting_for_year(year)
    wt = self.work_time_per_project(year)
    wt.each do |projectname, work_times|
      work_times.map! { |time| (time * self.wage_per_hour / 60).round(2) }
    end
  end

  def missing_timesheets(upto_date = Date.today - 1.month)
    upto_date = end_date if upto_date > end_date
    contract_dates = upto_date.downto(start_date.beginning_of_month)
                              .map { |d| d.change(day: 1) }.uniq
    # accepted and closed are scopes defined by the status enum
    valid_dates = (time_sheets.accepted | time_sheets.closed).map(&:first_day)
    contract_dates.delete_if{|date| valid_dates.include? date }
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
