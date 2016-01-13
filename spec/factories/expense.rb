FactoryGirl.define do
  factory :expense, class: 'Expense' do
    status 1
    user_id 1
    purpose 'Hana VM'
    amount 9_999_999
  end
end
