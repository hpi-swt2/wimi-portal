FactoryGirl.define do
  factory :event do
    user
    target_user { user }
    object { user }
    type 'test'
  end
end