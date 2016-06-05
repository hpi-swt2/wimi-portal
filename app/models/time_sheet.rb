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

  DEFAULT_SALARY = 10.00
  DEFAULT_WORKLOAD = 9
  
  scope :month, -> month { where(month: month) }
  scope :year, -> year { where(year: year) }
  scope :recent, -> { where('12 * year + month > ?', 12*Date.today.year + Date.today.month - 3) }
  scope :user, -> user { joins(:contract).where('contracts.hiwi_id' => user.id) }

  belongs_to :contract
  has_one :user, through: :contract, source: :hiwi
  enum status: [:pending, :accepted, :rejected]
  
  validates :month, numericality: {greater_than: 0}
  
  def work_days
    @work_days ||= WorkDay.time_sheet(self)
  end

  def sum_hours
    sum = 0
    work_days.each do |w|
      sum += w.duration
    end
    sum
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
