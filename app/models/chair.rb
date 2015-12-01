class Chair < ActiveRecord::Base
  has_many :wimis
  has_many :users, through: :wimis
  validates :name, presence: true
end
