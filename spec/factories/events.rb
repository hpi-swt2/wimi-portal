FactoryGirl.define do
  factory :event do
    trigger 0
    target 0
    seclevel :user
    type "Event"
  end
end
