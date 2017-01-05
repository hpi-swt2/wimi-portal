FactoryGirl.define do
  factory :dismissed_missing_timesheet do
    user nil
	contract nil
	month { Date.today.at_beginning_of_month }
  end
end
