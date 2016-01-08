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
    f.date "2015-11-18"
    f.start_time "2015-11-18 15:11:53"
    f.break 30
    f.end_time "2015-11-18 16:11:53"
    f.attendance ""
    f.notes "some note"
    f.user_id 1
    f.project
  end
end
