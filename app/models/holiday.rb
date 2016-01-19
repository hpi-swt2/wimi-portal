# == Schema Information
#
# Table name: holidays
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  start               :date
#  end                 :date
#  status              :integer          default(0), not null
#  replacement_user_id :integer
#  length              :integer
#  signature           :boolean
#  last_modified       :date
#  reason              :string
#  annotation          :string
#  length_last_year    :integer          default(0)
#

class Holiday < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user, :start, :end, :length
  validates_date :start
  validates_date :end, on_or_after: :start
  validate :too_far_in_the_future?
  enum status: [:saved, :applied, :accepted, :declined]

  def duration
    start.business_days_until(self.end + 1)
  end

  def calculate_length_difference(length_param)
    old_length = length.blank? ? 0 : length
    new_length = length_param
    unless new_length.blank?
      new_length = length_param
      length_difference = new_length.to_i - old_length
    else
      new_length = duration
      length_difference = duration - old_length
    end

    lengths = {length_difference: length_difference, new_length: new_length, old_length: old_length}
  end

  def user
    unless user_id.nil?
      User.find(user_id)
    end
  end

  private

  def too_far_in_the_future?
    unless self.end.blank? || self.end.year < Date.today.year + 2
      errors.add(:holiday, I18n.t('activerecord.errors.models.holiday.too_far_in_the_future'))
    end
  end
end
