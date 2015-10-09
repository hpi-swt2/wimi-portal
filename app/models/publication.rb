class Publication < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_one :project
end
