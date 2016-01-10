FactoryGirl.define do
  factory :holiday, class: 'Holiday' do
  	user_id 1
    start Date.today
    self.end (Date.today+1)
    length 1
  end
end