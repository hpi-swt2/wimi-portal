FactoryGirl.define do
  factory :holiday, class: 'Holiday' do
    status 'accepted'
    user_id 1
    start Date.today
    self.end (Date.today + 1)
  end
end
