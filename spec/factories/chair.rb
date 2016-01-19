FactoryGirl.define do
  factory :chair do
    name 'TestChair'

    after(:create) do |chair|
      FactoryGirl.create(:chair_representative, chair: chair, user: FactoryGirl.create(:user))
    end
  end
end
