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
#  signed                :boolean          default(FALSE)
#  handed_in             :boolean          default(FALSE)
#  last_modified         :date
#  status                :integer          default(0)
#  signer                :integer
#

FactoryGirl.define do
  factory :time_sheet do
    month 1
    year 1
    salary 1
    salary_is_per_month false
    workload 1
    workload_is_per_month false
    user_id 1
    project_id 1
  end
end
