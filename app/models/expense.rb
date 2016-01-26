# == Schema Information
#
# Table name: expenses
#
#  id               :integer          not null, primary key
#  inland           :boolean
#  country          :string
#  location_from    :string
#  location_via     :string
#  location_to      :string
#  reason           :text
#  car              :boolean
#  public_transport :boolean
#  vehicle_advance  :boolean
#  hotel            :boolean
#  status           :integer          default(0)
#  general_advance  :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  signature        :boolean
#  trip_id          :integer
#

class Expense < ActiveRecord::Base
  belongs_to :user
  belongs_to :trip
  has_many :expense_items
  accepts_nested_attributes_for :expense_items, reject_if: lambda {|attributes| attributes['date'].blank? }

  validates_presence_of :trip
  validates :location_from, presence: true
  validates :location_to, presence: true
  validates :general_advance, numericality: {greater_than_or_equal_to: 0}

  enum status: [:saved, :applied, :accepted, :declined]

  def first_name
    user.first_name
  end

  def last_name
    user.last_name
  end

  def get_signature
    user.signature
  end

  def date_start
    trip.date_start
  end

  def date_end
    trip.date_end
  end
end
