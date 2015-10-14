class Trip < ActiveRecord::Base
  belongs_to :users
  has_many :expenses

  validates_length_of :title, minimum: 1,  allow_blank: false
end
