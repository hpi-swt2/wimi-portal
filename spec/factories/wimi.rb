FactoryGirl.define do
  factory :wimi, class: 'User' do
    email
    password '12345678'
    password_confirmation '12345678'
    role :wimi
    projects {build_list :project, 1}
  end
end
