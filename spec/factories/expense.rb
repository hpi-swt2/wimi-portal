FactoryGirl.define do
  factory :expense, class: 'Expense' do
  	status 1
  	user_id 1
  	purpose 'Hana VM'
  	amount 9999999
  end
end