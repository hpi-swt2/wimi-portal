FactoryGirl.define do
  factory :trip_datespan do
    start_date Date.today
    end_date Date.today + 10
    days_abroad 5
    trip nil
  end

end
