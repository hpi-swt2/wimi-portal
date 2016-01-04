FactoryGirl.define do
  factory :wimi, class: 'ChairWimi' do
    # first_name          'James'
    # last_name           'Jones'
    # sequence(:email)    { |n| "person#{n}@example.com" }
    # # chair               {FactoryGirl.create(:chair, name: 'EPIC')}

    user_id nil
    chair_id nil
    application 'accepted'


    # after(:create) do |user|
    #   user.chair_wimi.update(application: 'accepted')
    # end
  end
end