# == Schema Information
#
# Table name: contracts
#
#  id             :integer          not null, primary key
#  start_date     :date
#  end_date       :date
#  chair_id       :integer
#  user_id        :integer
#  hiwi_id        :integer
#  responsible_id :integer
#  flexible       :boolean
#  hours_per_week :integer
#  wage_per_hour  :decimal(5, 2)
#  description    :text
#

FactoryGirl.define do
  factory :contract do
    start_date Date.today.at_beginning_of_month
    end_date Date.today.at_end_of_month
    flexible false
    hours_per_week 10
    wage_per_hour 10
    hiwi factory: :user
    description nil
    after(:build) do |contract|
      if contract.chair.blank?
        if contract.responsible
          contract.chair = contract.responsible.chair
        else
          contract.chair = FactoryGirl.create(:chair)
        end
      end
      if contract.responsible.blank?
        rep = contract.chair.representative
        if rep
          contract.responsible = contract.chair.representative.user
        else
          u = FactoryGirl.create(:wimi, chair: contract.chair, representative:true).user
          contract.responsible = u
        end
      end
    end
  end
end
