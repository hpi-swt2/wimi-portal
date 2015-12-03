FactoryGirl.define do
  factory :trip do
    name "Hana Travels"
    destination "NYC Conference"
    reason "Hana Things"
    start_date Date.today
    end_date Date.today + 6
    days_abroad 6
    annotation "HANA pls"
    signature "le Hasso"
    user
  end

  factory :trip2, parent: :trip do
    name "Space Adventures"
    days_abroad 3
  end

end
