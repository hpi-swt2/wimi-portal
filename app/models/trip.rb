# == Schema Information
#
# Table name: trips
#
#  id          :integer          not null, primary key
#  destination :string
#  reason      :text
#  annotation  :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :integer          default(0)
#  signature   :boolean
#

class Trip < ActiveRecord::Base
  belongs_to :user
  has_many :trip_datespans
  accepts_nested_attributes_for :trip_datespans, reject_if: lambda {|attributes| attributes['days_abroad'].blank?}
  validates :destination, presence: true
  validates :user, presence: true
  has_many :expenses
  enum status: [ :saved, :applied, :accepted, :declined ]

  def name
    self.user.first_name + ' ' + self.user.last_name
  end
end
