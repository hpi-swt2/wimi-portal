FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

FactoryGirl.define do
  factory :user, class: 'User' do
  	first 'John'
  	last_name 'Doe'
    email
    role :user
  end
end
