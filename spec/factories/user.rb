FactoryGirl.define do
  factory :user do
    sequence(:first)    { |n| "User #{n}" }
    last_name           "Last Name"
    email               "test@example.com"
  end
end
