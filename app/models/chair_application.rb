class ChairApplication < ActiveRecord::Base
  belongs_to :user
  belongs_to :chair

  enum status: [ :pending, :accepted, :declined ]
end
