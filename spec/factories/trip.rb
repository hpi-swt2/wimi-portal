FactoryBot.define do
  factory :trip do
    destination 'NYC Conference'
    reason 'Hana Things'
    annotation 'HANA pls'
    date_start Date.today
    date_end Date.today + 2
    days_abroad 1
    signature true
    user_signature 'signature'
    user_signed_at Date.today
    user
  end

  factory :trip2, parent: :trip do
    destination 'Space Adventures'
  end

  factory :trip_invalid, parent: :trip do
    destination ''
    date_end Date.today - 10
    days_abroad -20
  end
end
