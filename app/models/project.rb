class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :publications
  has_many :expenses
  belongs_to :chair
  validates :title, presence: true

  def hiwis
  	return users.select { |u| !u.is_wimi? }
  end

  def wimis
  	return users.select { |u| u.is_wimi? }
  end

end
