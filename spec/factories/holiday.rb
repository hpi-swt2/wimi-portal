FactoryGirl.define do
  factory :holiday, class: 'Holiday' do
  	status 'Holiday'
  	user_id 1
    start Date.today
    self.end (Date.today+1)
  end
end