# == Schema Information
#
# Table name: trips
#
#  id          :integer          not null, primary key
#  destination :string
#  reason      :text
#  annotation  :text
#  status      :string
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Trip < ActiveRecord::Base
  belongs_to :user
  has_many :trip_datespans
  accepts_nested_attributes_for :trip_datespans, reject_if: lambda {|attributes| attributes['days_abroad'].blank?}
  validates :destination, presence: true
  validates :user, presence: true
  has_many :expenses
  enum status: [ I18n.t('status.saved'), I18n.t('status.applied'),I18n.t('status.accepted'),I18n.t('status.declined')]

  before_validation(on: :create) do
    self.status = I18n.t('status.saved')
  end

  def name
    self.user.name
  end
end
