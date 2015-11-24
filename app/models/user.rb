class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :holiday
  has_many :expense
  has_many :trip
  has_and_belongs_to_many :publications
  has_and_belongs_to_many :projects

  def name
    "#{first} #{last_name}"
  end

  def name=(fullname)
    first, last = fullname.split(' ')
    self.first = first
    self.last_name = last
  end

  def self.language_list
    [['English', 'en'], ['German', 'de']]
  end
end
