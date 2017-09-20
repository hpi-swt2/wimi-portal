FactoryGirl.define do

  PROJECT_NAMES ||= ['Wimi Portal', 'SWT 2', 'Olelo', 'HANA Mining', 'In-Database-Memory']

  factory :project, class: 'Project' do
    sequence(:title) { |n| PROJECT_NAMES[(n.to_i - 1) % PROJECT_NAMES.length]}
    chair
  end
end
