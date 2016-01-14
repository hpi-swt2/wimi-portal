FactoryGirl.define do
  factory :hiwi, class: 'User' do
    first_name          'John'
    last_name           'Doe'
    sequence(:email)    { |_n| 'person#{n}@example.com' }
    projects            {build_list :project, 1}
  end
end
