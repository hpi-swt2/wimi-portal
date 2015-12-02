FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

FactoryGirl.define do
  factory :user, class: 'User' do
  	first_name 'John'
  	last_name 'Doe'
    email
    password '12345678'
    password_confirmation '12345678'
  end
end
