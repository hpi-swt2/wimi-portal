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

  validates :personnel_number, numericality: { only_integer: true }
  validate :personnel_number_in_range

  def personnel_number_in_range
    if !personnel_number.between?(0, 999999999)
      errors.add(:personnel_number, "needs to be between 0 and 999999999")
    end
  end

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
