FactoryGirl.define do
  factory :wimi, class: 'ChairWimi' do
    user_id { FactoryGirl.create(:user).id }
    chair_id nil
    application 'accepted'
  end
end
