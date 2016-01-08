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

require 'rails_helper'

RSpec.describe TravelExpenseReportItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
