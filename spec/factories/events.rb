FactoryGirl.define do
  factory :event do
    trigger_id 1
    target_id 1
    seclevel :user
    type "Event"
  end
end
