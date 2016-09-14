# == Schema Information
#
# Table name: time_sheets
#
#  id                       :integer          not null, primary key
#  month                    :integer
#  year                     :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  handed_in                :boolean          default(FALSE)
#  rejection_message        :text             default("")
#  signed                   :boolean          default(FALSE)
#  last_modified            :date
#  status                   :integer          default(0)
#  signer                   :integer
#  wimi_signed              :boolean          default(FALSE)
#  hand_in_date             :date
#  user_signature           :text
#  representative_signature :text
#  user_signed_at           :date
#  representative_signed_at :date
#  contract_id              :integer          not null
#

FactoryGirl.define do
  
  # If no contract is given, a new is created, 
  # using the optional `chair` parameter.
  factory :time_sheet do
    transient do
      user nil
      chair nil
    end
    month Date.today.month
    year Date.today.year
    last_modified Date.today
    hand_in_date nil
    rejection_message ''
    after(:build) do |ts, evaluator|
      if ts.contract.blank?
        args = {}
        args[:hiwi] = evaluator.user if evaluator.user
        args[:chair] = evaluator.chair if evaluator.chair
        ts.contract = FactoryGirl.create(:contract, args)
      end
    end
  end
end
