# == Schema Information
#
# Table name: time_sheets
#
#  id                    :integer          not null, primary key
#  month                 :integer
#  year                  :integer
#  salary                :integer
#  salary_is_per_month   :boolean
#  workload              :integer
#  workload_is_per_month :boolean
#  user_id               :integer
#  project_id            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  handed_in             :boolean          default(FALSE)
#  rejection_message     :text             default("")
#  signed                :boolean          default(FALSE)
#  last_modified         :date
#  status                :integer          default(0)
#  signer                :integer
#  wimi_signed           :boolean          default(FALSE)
#  hand_in_date          :date
#

FactoryGirl.define do
  factory :time_sheet do
    month Date.today.month
    year Date.today.year
    salary 100
    salary_is_per_month true
    workload 100
    workload_is_per_month true
    user_id 1
    project_id 1
    last_modified Date.today
    rejection_message ''
  end
end
