FactoryBot.define do
  factory :project_application, class: 'ProjectApplication' do
    project_id 1
    user_id 1
    status 'pending'
  end
end
