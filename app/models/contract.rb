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

  belongs_to :chair
  belongs_to :hiwi, class_name: 'User'
  belongs_to :responsible, class_name: 'User'
  has_many :time_sheets, -> { order(year: :desc, month: :desc) }

  validates_presence_of :start_date, :end_date, :chair, :hiwi, :responsible, :hours_per_week, :wage_per_hour
  validates :hours_per_week, numericality: {greater_than: 0}
  validates :wage_per_hour, numericality: {greater_than: 0}

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
    model = I18n.t('activerecord.models.contract.one')
    hiwi ? "#{hiwi.name} (#{date})" : "#{model} (#{date})"
  end

  def to_s
    name
  end

end
