FactoryGirl.define do
  factory :chair_representative, class: 'User' do
    first_name          'Jim'
    last_name           'Doe'
    sequence(:email)    { |n| "person#{n}@example.com" }
    chair               {FactoryGirl.create(:chair, name: 'EPIC')}


    after(:create) do |user|
      user.chair_wimi.update(application: 'accepted', representative: true)
    end
  end
end