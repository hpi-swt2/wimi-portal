FactoryGirl.define do
  factory :trip do
    name "Hana Travels"
    destination "NYC Conference"
    reason "Hana Things"
    start_date "2015-12-03"
    end_date "2015-12-10"
    days_abroad 6
    annotation "HANA pls"
    signature "le Hasso"
    user 1
  end

end
