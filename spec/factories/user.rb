FactoryGirl.define do
  factory :user do
    first               "Joe"
    last_name           "Doe"
    sequence(:email)    { |n| "person#{n}@example.com" }
  end
end
