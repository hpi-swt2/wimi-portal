# == Schema Information
#
# Table name: work_days
#
#  id            :integer          not null, primary key
#  date          :date
#  start_time    :time
#  break         :integer
#  end_time      :time
#  notes         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  time_sheet_id :integer
#

FactoryGirl.define do
  factory :work_day, class: 'WorkDay' do |f|
    f.date Date.today
    f.start_time Time.now.middle_of_day
    f.break 0
    f.end_time Time.now.middle_of_day + 2.hours
    f.notes 'some note'
    f.time_sheet
  end
end
