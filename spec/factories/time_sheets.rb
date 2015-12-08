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
