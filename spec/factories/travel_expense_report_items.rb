# == Schema Information
#
# Table name: travel_expense_report_items
#
#  id                       :integer          not null, primary key
#  date                     :date
#  breakfast                :boolean
#  lunch                    :boolean
#  dinner                   :boolean
#  travel_expense_report_id :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  annotation               :text
#

FactoryGirl.define do
  factory :travel_expense_report_item do
    date '2015-12-03'
    breakfast false
    lunch true
    dinner false
    travel_expense_report 1
  end
end
