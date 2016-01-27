FactoryGirl.define do
  factory :project, class: 'Project' do
    title 'Factory Project'
    chair {FactoryGirl.create(:chair)}
  end
end
