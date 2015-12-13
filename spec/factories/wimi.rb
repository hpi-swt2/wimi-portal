FactoryGirl.define do
  factory :wimi, class: 'User' do
    first_name          'Jim'
    last_name           'Doe'
    sequence(:email)    { |n| 'person#{n}@example.com' }
    chair               @chair
    projects          {build_list :project, 1}

    before(:create) do
      @chair = Chair.new(name: 'Another Test chair')
    end

    after(:create) do |user, factory|
      ChairWimi.new(chair_id: @chair, user: user, application: 'accepted')
    end
  end
end
