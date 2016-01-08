# == Schema Information
#
# Table name: travel_expense_reports
#
#  id               :integer          not null, primary key
#  inland           :boolean
#  country          :string
#  location_from    :string
#  location_via     :string
#  location_to      :string
#  reason           :text
#  date_start       :datetime
#  date_end         :datetime
#  car              :boolean
#  public_transport :boolean
#  vehicle_advance  :boolean
#  hotel            :boolean
#  general_advance  :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  signature        :boolean
#

class TravelExpenseReport < ActiveRecord::Base
  belongs_to :user
  has_many :travel_expense_report_items
  accepts_nested_attributes_for :travel_expense_report_items, reject_if: lambda {|attributes| attributes['date(1i)'].blank? or attributes['date(3i)'].blank? or attributes['date(2i)'].blank?}

  validates :general_advance, :numericality => { :greater_than_or_equal_to => 0 }
  validate 'start_before_end_date'


  def first_name
    self.user.first_name
  end

  def last_name
    self.user.last_name
  end

  def get_signature
    self.user.signature
  end

  def start_before_end_date
    if date_start > date_end
      errors.add(:date_start, "can't be after end date")
    end
  end
end
