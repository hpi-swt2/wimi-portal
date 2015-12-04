# == Schema Information
#
# Table name: expenses
#
#  id         :integer          not null, primary key
#  amount     :decimal(, )
#  purpose    :text
#  comment    :text
#  user_id    :integer
#  project_id :integer
#  trip_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Expense < ActiveRecord::Base
  has_one :user
  has_one :project
  has_one :trip

  validates :amount, format: {with: /\A\d+(?:\.\d{0,2})?\z/}, numericality: {greater_than: 0}
  validates_length_of :purpose, minimum: 1,  allow_blank: false
end
