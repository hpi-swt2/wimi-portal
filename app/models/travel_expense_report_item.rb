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
#

class TravelExpenseReportItem < ActiveRecord::Base
  belongs_to :travel_expense_report
end
