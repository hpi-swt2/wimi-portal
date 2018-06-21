FactoryBot.define do
  factory :superadmin, class: 'User' do
    first_name          'Jane'
    last_name           'Doe'
    sequence(:email)    { |n| "person#{n}@example.com" }
    superadmin          true
  end
end
