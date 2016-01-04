FactoryGirl.define do
  factory :wimi, class: 'User' do
    first_name          'James'
    last_name           'Jones'
    # sequence(:email)    { |n| "person#{n}@example.com" }
    chair               {FactoryGirl.create(:chair, name: 'EPIC')}


    after(:create) do |user|
      user.chair_wimi.update(application: 'accepted')
    end
  end
end