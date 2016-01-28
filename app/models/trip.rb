# == Schema Information
#
# Table name: trips
#
#  id                 :integer          not null, primary key
#  destination        :string
#  reason             :text
#  annotation         :text
#  user_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  status             :integer          default(0)
#  signature          :boolean
#  person_in_power_id :integer
#  last_modified      :date
#  date_start         :date
#  date_end           :date
#  days_abroad        :integer
#

class Trip < ActiveRecord::Base
  belongs_to :user
  has_one :expense
  validates_presence_of :destination, :user,:date_start,:date_end, :days_abroad
  validates :days_abroad, numericality: {greater_than_or_equal_to: 0}
  validate :start_before_end_date, :days_abroad_leq_to_total_days
  belongs_to :person_in_power, class_name: 'User'

  enum status: %w[saved applied accepted declined]

  before_validation(on: :create) do
    self.status = 'saved'
  end

  after_commit(on: :update) do
    if expense
      expense.update_item_count
    end
  end

  def name
    user.name
  end

  def has_expense?
    return !self.expense.nil?
  end

  def total_days
    (date_end - date_start).to_i + 1
  end

  private

  def days_abroad_leq_to_total_days
    #TODO: Geht das besser?
    if date_end && date_start && days_abroad && days_abroad > total_days
      errors.add(:days_abroad, "can't be larger than total days")
    end
  end

  def start_before_end_date
    if date_start && date_end && date_end < date_start
      errors.add(:date_start, "can't be before date_end")
    end
  end
end
