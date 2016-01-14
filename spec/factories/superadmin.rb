FactoryGirl.define do
  factory :superadmin, class: 'User' do
    first_name          'Jane'
    last_name           'Doe'
    sequence(:email)    { |_n| 'person#{n}@example.com' }
    superadmin          true
  end
end
