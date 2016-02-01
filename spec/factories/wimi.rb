FactoryGirl.define do
  factory :wimi, class: 'ChairWimi' do
    user
    chair
    application 'accepted'
  end
end
