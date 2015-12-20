FactoryGirl.define do
  factory :chair_representative, class: 'User' do
    first_name          'Peter'
    last_name           'Parker'
    sequence(:email)    { |n| "person#{n}@example.com" }
    chair               {FactoryGirl.create(:chair, name: 'Grafik')}


    after(:create) do |user|
      user.chair_wimi.update(application: 'accepted', representative: true)
    end
  end
end