FactoryGirl.define do
  factory :travel_expense_report do
    first_name "Hasso"
    last_name "Plattner"
    inland true
    country "Germany"
    location_from "Potsdam"
    location_via "London"
    location_to "NYC"
    reason "Hana Things"
    date_start 8.days.ago
    date_end DateTime.now
    car true
    public_transport true
    vehicle_advance false
    hotel true
    general_advance 2000
    user
  end

  factory :travel_expense_report_invalid, class: TravelExpenseReport do
    first_name ""
    last_name "Plattner"
    inland true
    country "Germany"
    location_from "Potsdam"
    location_via "London"
    location_to "NYC"
    reason "Hana Things"
    date_start DateTime.now
    date_end 8.days.ago
    car true
    public_transport true
    vehicle_advance false
    hotel true
    general_advance -20
    user
    to_create {|i| i.save(validate: false)}
  end

  factory :travel_expense_report_changed, parent: :travel_expense_report do
    first_name "Tobias"
    last_name "Friedrich"
    general_advance 1337
    car false
    hotel false
    vehicle_advance true
    date_start 5.days.ago
  end

  factory :travel_expense_report_blank_name, parent: :travel_expense_report do
    first_name ""
  end

  factory :travel_expense_report_wrong_dates, parent: :travel_expense_report do
    date_start DateTime.now
    date_end 8.days.ago
  end

  factory :travel_expense_report_negative_advance, parent: :travel_expense_report do
    general_advance -10
  end

end
