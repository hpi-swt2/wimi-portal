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
#  first_name                :string
#  last_name                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  identity_url              :string
#  language                  :string           default("en"), not null
#  residence                 :string
#  street                    :string
#  division_id               :integer          default(0)
#  personnel_number          :integer          default(0)
#  remaining_leave           :integer          default(28)
#  remaining_leave_last_year :integer          default(0)
#  superadmin                :boolean          default(FALSE)
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

<<<<<<< HEAD

=======
>>>>>>> dev
  LANGUAGES = [
    [
      'English',
      'en'
    ],
    [
      'Deutsch',
      'de'
    ],
  ]


  INVALID_EMAIL = 'invalid_email'

<<<<<<< HEAD
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
=======
  devise  :openid_authenticatable, :trackable
>>>>>>> dev

  has_many :work_days
  has_many :time_sheets
  has_many :holidays
  has_many :expenses
  has_many :trips
  has_many :invitations
  has_and_belongs_to_many :publications
  has_and_belongs_to_many :projects
  has_one :chair_wimi
  has_one :chair, through: :chair_wimi

  validates :first_name, length: { minimum: 1 }
  validates :last_name, length: { minimum: 1 }
  validates :email, length: { minimum: 1 }
  validates :personnel_number, numericality: { only_integer: true }, inclusion: 0..999999999
  validates_numericality_of :remaining_leave, greater_than_or_equal: 0
  validates_numericality_of :remaining_leave_last_year, greater_than_or_equal: 0

  # TODO: implement signature upload, this is a placeholder
  def signature
    'placeholder'
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name=(fullname)
    first, last = fullname.split(' ')
    self.first_name = first
    self.last_name = last
  end

<<<<<<< HEAD
=======
  def projects_for_month(year, month)
    projects = TimeSheet.where(
      user: self, month: month, year: year).map {|sheet| sheet.project}
    return (projects.compact + self.projects).uniq
  end

  def years_and_months_of_existence
    year_months = []
    creation_date = self.created_at
    (creation_date.year..Date.today.year).each do |year|
      start_month = (creation_date.year == year) ? creation_date.month : 1
      end_month = (Date.today.year == year) ? Date.today.month : 12
      (start_month..end_month).each do |month|
        year_months.push([year, month])
      end
    end
    return year_months
  end

  def is_user?
    not is_wimi? and not is_superadmin? and not is_hiwi?
  end

>>>>>>> dev
  def prepare_leave_for_new_year
    self.remaining_leave_last_year = self.remaining_leave
    self.remaining_leave = 28
  end

  def is_wimi?
    not chair_wimi.nil? and (chair_wimi.admin or chair_wimi.representative or chair_wimi.application == 'accepted')
  end

  def is_representative?(opt_chair = false)
    return false if chair_wimi.nil?
    if opt_chair
      return false if opt_chair != chair
    end
    return chair_wimi.representative
  end

  def is_admin?(opt_chair = false)
    return false if chair_wimi.nil?
    if opt_chair
      return false if opt_chair != chair
    end
    return chair_wimi.admin
  end

  def is_hiwi?
    projects and projects.size > 0 and not is_wimi?
  end

  def is_superadmin?
    self.superadmin
  end

  def self.openid_required_fields
    ["http://axschema.org/contact/email"]
  end

  def self.build_from_identity_url(identity_url)
    username = identity_url.split('/')[-1]
    first_name = username.split('.')[0].titleize
    last_name = username.split('.')[1].titleize.delete("0-9")
    User.new(first_name: first_name, last_name: last_name, identity_url: identity_url)
  end

  def openid_fields=(fields)
    fields.each do |key, value|
      if value.is_a? Array
        value = value.first
      end

      # if no email is saved yet and we receive no address, set INVALID_EMAIL as address, otherwise save the received value
      if key.to_s == "http://axschema.org/contact/email"
        if email.blank?
          if value.blank?
            update_attribute(:email, INVALID_EMAIL)
          else
            update_attribute(:email, value)
          end
        end
      end
    end
<<<<<<< HEAD
  end
  
  def projects_for_month(year, month)
    projects = TimeSheet.where(
      user: self, month: month, year: year).map {|sheet| sheet.project}
    p (projects.compact + self.projects).uniq
    return (projects.compact + self.projects).uniq

=======
>>>>>>> dev
  end
end
