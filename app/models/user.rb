# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string           default(""), not null
#  first_name                :string
#  last_name                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  identity_url              :string
#  language                  :string           default("en"), not null
#  street                    :string
#  personnel_number          :integer          default(0)
#  remaining_leave           :integer          default(28)
#  remaining_leave_last_year :integer          default(0)
#  superadmin                :boolean          default(FALSE)
#  username                  :string
#  encrypted_password        :string           default(""), not null
#  city                      :string
#  zip_code                  :string
#  signature                 :text
#  email_notification        :boolean          default(FALSE)
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :string
#  last_sign_in_ip           :string
#  include_comments          :integer
#  event_settings            :string
#

class User < ActiveRecord::Base
  LANGUAGES = [
    %w[English en],
    %w[Deutsch de],
  ]
  
  devise :trackable, :openid_authenticatable, :database_authenticatable, :registerable, authentication_keys: [:username]

  has_many :contracts, foreign_key: :hiwi_id
  has_many :time_sheets, through: :contracts
  has_many :responsible_contracts, foreign_key: :responsible_id, class_name: 'Contract'
  has_many :responsible_time_sheets, through: :responsible_contracts, source: :time_sheets, class_name: 'TimeSheet'
  has_many :holidays
  has_many :expenses
  has_many :project_applications, dependent: :destroy
  has_many :trips
  has_many :caused_events , class_name: 'Event', :dependent => :destroy
  has_many :targeted_events, class_name: 'Event', foreign_key: :target_user_id, :dependent => :destroy
  has_and_belongs_to_many :projects
  has_one :chair_wimi
  has_one :chair, through: :chair_wimi

  enum include_comments: [:always, :never, :ask]

  serialize :event_settings, Array

  validate :validate_event_settings
  validates :first_name, length: {minimum: 1}
  validates :last_name, length: {minimum: 1}
  validates :email, user_email: true
  validates :personnel_number, numericality: {only_integer: true}, inclusion: 0..999999999, allow_blank: true
  validates_numericality_of :remaining_leave, greater_than_or_equal_to: 0
  validates_numericality_of :remaining_leave_last_year, greater_than_or_equal_to: 0
  validates_confirmation_of :password
  validates_uniqueness_of :identity_url, allow_nil: true, allow_blank: true

  after_initialize :set_event_settings, if: :new_record?

  def name
    "#{first_name} #{last_name}"
  end

  # Return all chairs that the user is connected with,
  # either because he is a WiMi or a HiWi.
  # :chair returns only those chairs that the user is a _WiMi_ in
  def all_chairs
    if chair.nil?
      chair_hiwi
    else
      ([chair] + chair_hiwi).uniq
    end
  end

  # Return all chairs that the user is a HiWi in
  def chair_hiwi
    contracts.collect(&:chair).uniq
  end

  def name=(fullname)
    first, last = fullname.split(' ')
    self.first_name = first
    self.last_name = last
  end

  def name_with_email
    "#{first_name} #{last_name} (#{email})"
  end

  def prepare_leave_for_new_year
    self.remaining_leave_last_year = remaining_leave
    self.remaining_leave = 28
  end

  def is_user?
    !is_wimi? and !is_superadmin? and !is_hiwi?
  end

  def is_student?
    !is_wimi? and !is_superadmin?
  end

  def is_wimi?
    !chair_wimi.nil? and (chair_wimi.admin or chair_wimi.representative or chair_wimi.application == 'accepted')
  end

  def is_representative?(opt_chair = false)
    return false if chair_wimi.nil?
    if opt_chair
      return false if opt_chair != chair
    end
    chair_wimi.representative
  end

  def is_admin?(opt_chair = false)
    return false if chair_wimi.nil?
    if opt_chair
      return false if opt_chair != chair
    end
    chair_wimi.admin
  end

  def is_hiwi?
    !projects.blank? and  !is_wimi?
  end

  def is_superadmin?
    superadmin
  end

  def current_contracts
    contracts.where(["end_date >= ?", Date.today])
  end
  
  def recent_contracts
    contracts.where(["end_date >= ?", 3.months.ago])
  end

  def contract_with(chair)
    Contract.contract_with(self,chair)
  end

  def has_contract_for(month, year)
    return Contract.for_user_in_month(self, month, year).size > 0
  end
  
  def time_sheets_for(date_or_month, year = -1)
    if year < 0
      d_start = d_end = date_or_month
      month = d_start.month
      year = d_start.year
    else
      month = date_or_month
      d_start = Date.new(year, month).at_beginning_of_month
      d_end = d_start.at_end_of_month
    end
    c_start_date = Contract.arel_table[:start_date]
    c_end_date = Contract.arel_table[:end_date]
    sheets = contracts.where(c_start_date.lteq(d_end), c_end_date.gteq(d_start)).inject([]) do |list, contract|
      ts = contract.time_sheet(month, year)
      list << ts if ts
      return list
    end
    sheets.uniq
  end

  def self.openid_required_fields
    ['http://axschema.org/contact/email']
  end

  def self.build_from_email(email)
    regex_match = /\A([a-zA-Z]+\.[a-zA-Z0-9]+)@(student\.){0,1}hpi\.(uni-potsdam\.){0,1}de\z/i.match(email)
    if regex_match
      identity_url_base = Rails.configuration.identity_url
      user = self.build_from_identity_url(identity_url_base + regex_match[1])
      user.email = email
      return user
    else
      return nil
    end
  end

  def self.build_from_identity_url(identity_url)
    username = identity_url.split('/')[-1]
    first_name = username.split('.')[0].titleize
    last_name = username.split('.')[1].titleize.delete('0-9')
    User.new(first_name: first_name, last_name: last_name, identity_url: identity_url)
  end

  def openid_fields=(fields)
    fields.each do |key, value|
      if value.is_a? Array
        value = value.first
      end
      
      # if no email is saved yet and we receive no address, set "" as address, otherwise save the received value
      if key.to_s == 'http://axschema.org/contact/email'
        if email.blank?
          if value.blank?
            update_attribute(:email, "")
          else
            update_attribute(:email, value)
          end
        end
      end
    end
  end

  def get_desc_sorted_trips
    all_trips = Trip.where(user_id: id)
    trips = []
    all_trips.each do |trip|
      trips.push(trip)
    end
    trips.sort! { |a, b| b.date_start <=> a.date_start }
  end

  def clear_event_settings
    update(event_settings: [])
  end

  def wants_mail_for(event_int)
    self.event_settings.include?(event_int)
  end

  # Allow querying user's abilities directly
  # http://wiki.github.com/ryanb/cancan/ability-for-other-users
  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, :to => :ability

  private

  def validate_event_settings
    if !event_settings.is_a?(Array) || event_settings.any?{|i| not Event.types.values.include?(i)}
      errors.add(:event_settings, :invalid)
    end
  end

  def set_event_settings
    self.event_settings = Event.types.values
  end
end
