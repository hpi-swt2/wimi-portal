FactoryGirl.define do
  factory :chair_representative, class: 'ChairWimi' do
    user_id nil
    chair_id nil
    application 'accepted'
    representative true
  end
end