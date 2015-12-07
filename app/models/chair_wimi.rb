class ChairWimi < ActiveRecord::Base
  belongs_to :user
  belongs_to :chair
  validates :user, :chair, presence: true

end
