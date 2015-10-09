class Trip < ActiveRecord::Base
  belongs_to :users
  has_many :expenses
end
