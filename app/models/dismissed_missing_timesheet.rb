class DismissedMissingTimesheet < ActiveRecord::Base
  scope :user, -> user { where(user: user)}
  scope :dates_for, -> user, contract { where(user:user, contract: contract).collect{|entry| entry.month} }

  belongs_to :user
  belongs_to :contract

  validates :user, :contract, presence: true
end
