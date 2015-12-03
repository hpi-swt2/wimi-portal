# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string           default(""), not null
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :string
#  last_sign_in_ip           :string
#  first                     :string
#  last_name                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  remaining_leave           :integer          default(28)
#  remaining_leave_last_year :integer          default(0)
#  residence                 :string
#  street                    :string
#  division                  :string
#  personnel_number          :integer          default(1)
#

class User < ActiveRecord::Base

  DIVISIONS = [ '',
      'Enterprise Platform and Integration Concepts',
      'Internet-Technologien und Systeme',
      'Human Computer Interaction',
      'Computergrafische Systeme',
      'Algorithm Engineering',
      'Systemanalyse und Modellierung',
      'Software-Architekturen',
      'Informationssysteme',
      'Betriebssysteme und Middleware',
      'Business Process Technology',
      'School of Design Thinking',
      'Knowledge Discovery and Data Mining']

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :work_days
  has_many :time_sheets
  has_many :holidays
  has_many :expenses
  has_many :trips
  has_and_belongs_to_many :publications
  has_and_belongs_to_many :projects

  validates :personnel_number, numericality: { only_integer: true }, inclusion: 0..999999999
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

  def projects_for_month(year, month)
    projects = TimeSheet.where(
      user: self, month: month, year: year).map {|sheet| sheet.project}
    p (projects.compact + self.projects).uniq
    return (projects.compact + self.projects).uniq
  end
end
