# == Schema Information
#
# Table name: expense_items
#
#  id                       :integer          not null, primary key
#  date                     :date
#  breakfast                :boolean
#  lunch                    :boolean
#  dinner                   :boolean
#  expense_id :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  annotation               :text
#

FactoryGirl.define do
  factory :expense_item do
    date '2015-12-03'
    breakfast false
    lunch true
    dinner false
    expense 1
  end
end
