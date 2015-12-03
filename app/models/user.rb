# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string           default(""), not null
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :string
#  last_sign_in_ip           :string
#  first                     :string
#  last_name                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  identity_url              :string
#  remaining_leave_this_year :integer          default(28)
#  remaining_leave_next_year :integer          default(28)
#

class User < ActiveRecord::Base

  DIVISIONS = [
    ['', ''],
    [
      'Enterprise Platform and Integration Concepts',
      'Enterprise Platform and Integration Concepts'
    ],
    [
      'Internet-Technologien und Systeme',
      'Internet-Technologien und Systeme'
    ],
    [
      'Human Computer Interaction',
      'Human Computer Interaction'
    ],
    [
      'Computergrafische Systeme',
      'Computergrafische Systeme'
    ],
    [
      'Algorithm Engineering',
      'Algorithm Engineering'
    ],
    [
      'Systemanalyse und Modellierung',
      'Systemanalyse und Modellierung'
    ],
    [
      'Software-Architekturen',
      'Software-Architekturen'
    ],
    [
      'Informationssysteme',
      'Informationssysteme'
    ],
    [
      'Betriebssysteme und Middleware',
      'Betriebssysteme und Middleware'
    ],
    [
      'Business Process Technology',
      'Business Process Technology'
    ],
    [
      'School of Design Thinking',
      'School of Design Thinking'
    ],
    [
      'Knowledge Discovery and Data Mining',
      'Knowledge Discovery and Data Mining'
    ]
  ]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :holidays
  has_many :expenses
  has_many :trips
  has_and_belongs_to_many :publications
  has_and_belongs_to_many :projects

  validates :personnel_number, numericality: { only_integer: true }
  validates_numericality_of :remaining_leave, greater_than_or_equal: 0
  validates_numericality_of :remaining_leave_last_year, greater_than_or_equal: 0

  def name
    "#{first} #{last_name}"
  end

  def name=(fullname)
    first, last = fullname.split(' ')
    self.first = first
    self.last_name = last
  end
end
