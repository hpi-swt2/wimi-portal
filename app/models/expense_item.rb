# == Schema Information
#
# Table name: expense_items
#
#  id         :integer          not null, primary key
#  date       :date
#  breakfast  :boolean
#  lunch      :boolean
#  dinner     :boolean
#  expense_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  annotation :text
#

class ExpenseItem < ActiveRecord::Base
  belongs_to :expense
end
