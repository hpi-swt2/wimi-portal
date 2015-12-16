FactoryGirl.define do
  factory :travel_expense_report_item do
    date "2015-12-03"
    breakfast false
    lunch true
    dinner false
    travel_expense_report 1
  end

end
