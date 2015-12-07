class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :holidays
  has_many :expenses
  has_many :trips
  has_and_belongs_to_many :publications
  has_and_belongs_to_many :projects
  has_one :chair_wimi
  has_one :chair, through: :chair_wimi

  def name
    "#{first_name} #{last_name}"
  end

  def name=(fullname)
    first, last = fullname.split(' ')
    self.first_name = first
    self.last_name = last
  end

  def is_wimi?
    return false if chair_wimi.nil?
    return chair_wimi.admin || chair_wimi.representative || chair_wimi.application == 'accepted'
  end

  Roles = [ :superadmin, :admin, :representative, :wimi, :hiwi, :user ]

  def is?( requested_role )
    self.role == requested_role.to_s
  end
end
