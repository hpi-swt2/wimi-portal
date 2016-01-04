FactoryGirl.define do
  factory :chair_representative, class: 'ChairWimi' do
    # first_name          'Peter'
    # last_name           'Parker'
    # sequence(:email)    { |n| "person#{n}@example.com" }
    # chair               {FactoryGirl.create(:chair, name: 'Grafik')}

    user_id nil
    chair_id nil
    application 'accepted'
    representative true


    # after(:create) do |user|
    #   user.chair_wimi.update(application: 'accepted', representative: true)
    # end
  end
end