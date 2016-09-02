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
  enum status: [:pending, :accepted, :rejected]
  has_many :work_days, :inverse_of => :time_sheet
  
  validates :month, numericality: {greater_than: 0}
  validates :year, numericality: {greater_than: 0}

  accepts_nested_attributes_for :work_days

  def sum_hours
    #sum = 0
    #work_days.each do |w|
    #  sum += w.duration
    #end
    #sum
  end

  def sum_minutes
    #sum_hours * 60
  end

  def sum_minutes_formatted
    #work_time = sum_minutes
    #minutes = work_time % 60
    #hours = (work_time - minutes) / 60
    #format("%d:%02d", hours, minutes)
  end

  def generate_work_days
    first_day = Date.new(year,month,1)
    last_day = first_day.end_of_month
    (first_day..last_day).each do |day|
      work_days.new(date: day)
    end
  end
end
