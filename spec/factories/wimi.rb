FactoryGirl.define do
  factory :wimi, class: 'User' do
    email
    password '12345678'
    password_confirmation '12345678'
  end
end
