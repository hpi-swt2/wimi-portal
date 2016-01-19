# == Schema Information
#
# Table name: work_days
#
#  id         :integer          not null, primary key
#  date       :date
#  start_time :time
#  break      :integer
#  end_time   :time
#  attendance :string
#  notes      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  project_id :integer
#

FactoryGirl.define do
  factory :work_day, class: 'WorkDay' do |f|
    f.date Date.today
    f.start_time Time.now.middle_of_day
    f.break 30
    f.end_time Time.now.middle_of_day + 2.hours
    f.attendance ''
    f.notes 'some note'
    f.user_id 1
    f.project_id 1
  end
end
