FactoryGirl.define do
  factory :wimi, class: 'User' do
    first_name          'Jim'
    last_name           'Doe'
    sequence(:email)    { |n| 'person#{n}@example.com' }

    after(:create) do |user, factory|
      chair1 = FactoryGirl.create(:chair)
      wimi1 = FactoryGirl.create(:chair_wimi, user: user, chair: chair1, application: 'accepted')
    end
  end
end
