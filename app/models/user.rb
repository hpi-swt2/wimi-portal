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
  has_one :wimi

  def name
    "#{first_name} #{last_name}"
  end

  def name=(fullname)
    first, last = fullname.split(' ')
    self.first_name = first
    self.last_name = last
  end

  def is_wimi?
    if self.wimi.nil?
      return false
    else
      return true
    end
  end
end
