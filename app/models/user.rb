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
#

class User < ActiveRecord::Base
  LANGUAGES = [
    %w[English en],
    %w[Deutsch de],
  ]

  INVALID_EMAIL = 'invalid_email'

  devise :trackable, :openid_authenticatable, :database_authenticatable, :registerable, authentication_keys: [:username]

  has_many :contracts, foreign_key: :hiwi_id
  has_many :time_sheets, through: :contracts
  has_many :responsible_contracts, foreign_key: :responsible_id, class_name: 'Contract'
  has_many :responsible_time_sheets, through: :responsible_contracts, source: :time_sheets, class_name: 'TimeSheet'
  has_many :holidays
  has_many :expenses
  has_many :project_applications, dependent: :destroy
  has_many :trips
  has_many :invitations
  has_and_belongs_to_many :projects
  has_one :chair_wimi
  has_one :chair, through: :chair_wimi

  validates :first_name, length: {minimum: 1}
  validates :last_name, length: {minimum: 1}
  validates :email, length: {minimum: 1}, user_email: true
  validates :personnel_number, numericality: {only_integer: true}, inclusion: 0..999999999, allow_blank: true
  validates_numericality_of :remaining_leave, greater_than_or_equal_to: 0
  validates_numericality_of :remaining_leave_last_year, greater_than_or_equal_to: 0
  validates_format_of :zip_code, with: /(\A\d{5}\Z)|(\A\Z)/i
  validates_confirmation_of :password

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
    projects.collect(&:chair).uniq
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
  
  def recent_contracts
    unless @recent_contracts
      c_end_date = Contract.arel_table[:end_date]
      past_3_months = Date.today - 3.months
      @recent_contracts = contracts.where(c_end_date.gteq(past_3_months))
    end
    @recent_contracts
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
      
      # if no email is saved yet and we receive no address, set INVALID_EMAIL as address, otherwise save the received value
      if key.to_s == 'http://axschema.org/contact/email'
        if email.blank?
          if value.blank?
            update_attribute(:email, INVALID_EMAIL)
          else
            update_attribute(:email, value)
          end
        end
      end
    end
  end

  def self.search(search, chair)
    if search.length > 0
      results = where('first_name LIKE ? or last_name LIKE ?', "%#{search}%", "%#{search}%")
      results = results.reject(&:is_superadmin?)
      if chair
        return results.reject { |u| u.is_wimi? && u.chair != chair }
      else
        return results.reject(&:is_wimi?)
      end
    else
      return nil
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

  def create_notification_arrays
    #activities are events you dont necessarily need to react to
    # => get destroyed if they're not under the newest 50
    #notifications are events you need to react to
    # => get destroyed when you react to them

    act = []
    noti = []

    # Chair-Applications: apply
    noti += Event.where(chair: chair).where(type: 'EventChairApplication') if is_admin?

    # Chair-Applications: accept
    act += Event.where(target_id: id).where(type: 'EventUserChair').where(status: 'added')
    act += Event.where(chair: chair).where(type: 'EventUserChair').where(status: 'added') if is_wimi?

    # Chair-Applications: decline
    act += Event.where(target_id: id).where(type: 'EventUserChair').where(status: 'declined')
    act += Event.where(chair: chair).where(type: 'EventUserChair').where(status: 'declined') if is_admin?

    # Chair-Applications: remove
    act += Event.where(target_id: id).where(type: 'EventUserChair').where(status: 'removed')
    act += Event.where(chair: chair).where(type: 'EventUserChair').where(status: 'removed') if is_wimi?

    # Chair-Admins: granted
    act += Event.where(target_id: id).where(type: 'EventAdminRight').where(status: 'added')
    act += Event.where(chair: chair).where(type: 'EventAdminRight').where(status: 'added') if is_admin?

    # Chair-Admins: granted
    act += Event.where(target_id: id).where(type: 'EventAdminRight').where(status: 'removed')
    act += Event.where(chair: chair).where(type: 'EventAdminRight').where(status: 'removed') if is_admin?

    # Holiday-/Trip-/Expense-Requests
    act += Event.where(trigger_id: id).where(type: 'EventRequest')
    noti += Event.where(chair: chair).where(type: 'EventRequest') if is_representative?

    act += Event.where(target_id: id).where(type: 'EventTravelRequestAccepted')
    act += Event.where(target_id: id).where(type: 'EventTravelRequestDeclined')

    # Holiday-Requests: accepted / declined
    act += Event.where(chair: chair).where(type: 'EventHolidayRequest') if is_representative?
    act += Event.where(target_id: id).where(type: 'EventHolidayRequest')

    # Project-Invitation
    noti += Event.where(target_id: id).where(type: 'EventProjectInvitation')

    # Time-Sheets
    act += Event.where(target_id: id).where(type: 'EventTimeSheetAccepted')
    act += Event.where(target_id: id).where(type: 'EventTimeSheetDeclined')
    Contract.all.where(responsible: self).each do |contract|
      noti += Event.where(target_id: contract.id).where(type: 'EventTimeSheetSubmitted') if is_wimi?
    end

    noti.delete_if { |event| event.is_hidden_by(self) }
    act.delete_if { |event| event.is_hidden_by(self) }

    noti = noti.uniq.sort_by { |n| n[:created_at] }.reverse
    act = act.uniq.sort_by { |n| n[:created_at] }.reverse

    to_delete = act.drop(50)
    to_delete.each(&:destroy!)

    act = act.take(50)

    return [act,noti]
  end
end
