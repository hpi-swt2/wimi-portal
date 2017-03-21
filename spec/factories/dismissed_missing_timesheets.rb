# == Schema Information
#
# Table name: dismissed_missing_timesheets
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  contract_id :integer
#  month       :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :dismissed_missing_timesheet do
    user nil
	contract nil
	month { Date.today.at_beginning_of_month }
  end
end
