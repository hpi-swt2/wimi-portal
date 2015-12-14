FactoryGirl.define do
  factory :trip do
    name "Hana Travels"
    destination "NYC Conference"
    reason "Hana Things"
    annotation "HANA pls"
    signature "le Hasso"
    status "saved"
    user
  end

  factory :trip2, parent: :trip do
    name "Space Adventures"
  end

end
