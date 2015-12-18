FactoryGirl.define do
  factory :wimi, class: 'User' do
    first_name          'John'
    last_name           'Doe'
    sequence(:email)    { |n| "person#{n}@example.com" }
    chair               FactoryGirl.create(:chair)
    projects            {build_list :project, 1}

    after(:create) do |user, factory|
      user.chair_wimi.update(application: 'accepted')
    end
  end
end
