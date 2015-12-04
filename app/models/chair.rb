class Chair < ActiveRecord::Base
  has_many :chair_wimis
  has_many :users, through: :chair_wimis
  has_many :projects

  validates :name, presence: true

  def wimis
  	return users.select { |u| u.is_wimi? }
  end

  def hiwis
  	arr = []
  	projects.each do |p|
  		arr += p.hiwis
  	end
  	return arr
  end

end
