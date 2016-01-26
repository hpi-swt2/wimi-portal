# == Schema Information
#
# Table name: trips
#
#  id            :integer          not null, primary key
#  destination   :string
#  reason        :text
#  annotation    :text
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  status        :integer          default(0)
#  signature     :boolean
#  last_modified :date
#

class Trip < ActiveRecord::Base
  belongs_to :user
  has_one :expense
  has_many :trip_datespans
  accepts_nested_attributes_for :trip_datespans, reject_if: lambda {|attributes| attributes['days_abroad'].blank?}
  validates :destination, presence: true
  validates :user, presence: true
  has_many :expenses

  enum status: %w[saved applied accepted declined]

  before_validation(on: :create) do
    self.status = 'saved'
  end

  def name
    user.name
  end

  def has_expense?
    return !self.expense.nil?
  end
end
