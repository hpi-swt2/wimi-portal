FactoryGirl.define do
  factory :chair do
    name "TestChair"

    after(:create) do |chair|
      FactoryGirl.create(:chair_representative, chair_id:chair.id, user_id: FactoryGirl.create(:user).id)
    end
  end
end
