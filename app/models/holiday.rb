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
#  reason              :string
#  annotation          :string
#  replacement_user_id :integer
#  length              :integer
#  signature           :boolean
#  last_modified       :date
#

class Holiday < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user, :start, :end
  validates_date :start, on_or_after: :today
  validates_date :end, on_or_after: :start
  validate :length
  validate :too_far_in_the_future?
  validate :sufficient_leave_left?
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

  private

  def too_far_in_the_future?
    unless self.end.blank? || self.end.year < Date.today.year + 2
      errors.add(:Holiday, 'is too far in the future')
    end
  end

  def sufficient_leave_left?
    #need to assert that user is existent for tests
    return unless errors.blank?
    if user
      unless user.remaining_leave >= (length.nil? ? duration : length)
        errors.add(:not_enough_leave_left!, '')
      end
    end
  end
end