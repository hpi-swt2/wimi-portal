FactoryGirl.define do
  factory :wimi, class: 'User' do
    first 'John'
    last_name 'Doe'
    email
    role :wimi
    projects {build_list :project, 1}
  end
end
