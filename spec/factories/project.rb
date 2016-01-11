FactoryGirl.define do
  factory :project do
    title 'Factory Project'
    chair {FactoryGirl.create(:chair)}
  end
end
