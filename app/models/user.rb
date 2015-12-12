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
#  first_name                :string
#  last_name                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  identity_url              :string
#  remaining_leave_this_year :integer          default(28)
#  remaining_leave_next_year :integer          default(28)
#  residence                 :string
#  street                    :string
#  division_id               :integer          default(0)
#  personnel_number          :integer          default(0)
#

class User < ActiveRecord::Base

  devise  :openid_authenticatable, :trackable

  validates :first_name, length: { minimum: 1 }
  validates :last_name, length: { minimum: 1 }
  validates :email, length: { minimum: 1 }

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

  INVALID_EMAIL = 'invalid_email'

  has_many :holidays
  has_many :expenses
  has_many :trips
  has_many :notifications

  has_and_belongs_to_many :publications
  has_and_belongs_to_many :projects
  has_one :chair_wimi
  has_one :chair, through: :chair_wimi

  validates :personnel_number, numericality: { only_integer: true }, inclusion: 0..999999999
  validates_numericality_of :remaining_leave, greater_than_or_equal: 0
  validates_numericality_of :remaining_leave_last_year, greater_than_or_equal: 0

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

  def self.openid_required_fields
    ["http://axschema.org/contact/email"]
  end

  def self.build_from_identity_url(identity_url)
    username = identity_url.split('/')[-1]
    first_name = username.split('.')[0].titleize
    last_name = username.split('.')[1].titleize.delete("0-9")
    User.new(:first_name => first_name, :last_name => last_name, :identity_url => identity_url)
  end

  def openid_fields=(fields)
    fields.each do |key, value|
      if value.is_a? Array
        value = value.first
      end

      if key.to_s == "http://axschema.org/contact/email"
        if value.nil?
          update_attribute(:email, INVALID_EMAIL)
        else
          update_attribute(:email, value)
        end
      end
    end
  end
end
