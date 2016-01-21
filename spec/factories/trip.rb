FactoryGirl.define do
  factory :trip do
    destination 'NYC Conference'
    reason 'Hana Things'
    annotation 'HANA pls'
    signature true
    user
  end

  factory :trip2, parent: :trip do
    destination 'Space Adventures'
  end
end
