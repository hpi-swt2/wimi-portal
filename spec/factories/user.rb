FactoryGirl.define do
  factory :user do
    first_name          "Joe"
    last_name           "Doe"
    sequence(:email)    { |n| "person#{n}@example.com" }
  end
end
