class Expense < ActiveRecord::Base
  has_one :user
  has_one :project
  has_one :trip
end
