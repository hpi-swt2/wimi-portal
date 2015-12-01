class Chair < ActiveRecord::Base
  validates :name, presence: true
end
