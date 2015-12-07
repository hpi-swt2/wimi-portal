class Chair < ActiveRecord::Base
  has_many :chair_wimis, dependent: :destroy
  has_many :users, through: :chair_wimis
  has_many :projects

  validates :name, presence: true

  def wimis
  	users.select { |u| u.is_wimi? }
  end

  def hiwis
  	projects.collect { |p| p.hiwis }
  end

end
