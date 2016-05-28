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
  belongs_to :chair
  belongs_to :hiwi, class_name: 'User'
  belongs_to :responsible, class_name: 'User'
  has_many :time_sheets

  validates_presence_of :start_date, :end_date, :chair, :hiwi, :responsible, :hours_per_week, :wage_per_hour
  validates :hours_per_week, numericality: {greater_than: 0}
  validates :wage_per_hour, numericality: {greater_than: 0}

  def time_sheet(month, year)
    d_start = Date.new(year, month).at_beginning_of_month
    d_end = d_start.at_end_of_month
    return nil unless start_date < d_end and end_date > d_start
    ts = time_sheets.month(month).year(year).first
    ts || TimeSheet.create!(month: month, year: year, contract: self)
  end
  
end
