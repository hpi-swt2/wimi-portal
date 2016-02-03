# == Schema Information
#
# Table name: expenses
#
#  id               :integer          not null, primary key
#  inland           :boolean
#  country          :string
#  location_from    :string
#  location_via     :string
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
#  time_start       :string
#  time_end         :string
#

class Expense < ActiveRecord::Base
  belongs_to :user
  belongs_to :trip
  has_many :expense_items
  accepts_nested_attributes_for :expense_items

  validates_presence_of :trip, :location_from, :time_start, :time_end
  validates :general_advance, numericality: {greater_than_or_equal_to: 0}
  validate :time_format

  enum status: [:saved, :applied, :accepted, :declined]

  def first_name
    user.first_name
  end

  def last_name
    user.last_name
  end

  def date_start
    trip.date_start
  end

  def date_end
    trip.date_end
  end

  def location_to
    trip.destination
  end

  def update_item_count
    expense_items.each do |item|
      if item.date > trip.date_end || item.date < trip.date_start
        item.destroy
      end
    end

    for i in 0..(trip.total_days - 1)
      unless expense_items.include?(ExpenseItem.find_by_date_and_expense_id(trip.date_start + i, id))
        add_expense_item(trip.date_start + i)
      end
    end
  end

  private

  def add_expense_item(date)
    day = expense_items.build
    day.date = date
    day.breakfast = false
    day.lunch = false
    day.dinner = false
    day.save
  end

  def time_format
    if time_start && !time_start.match(/\A(?:[0-1]?[0-9]|2[0-3]):[0-5][0-9]/)
      errors.add(:time_start, I18n.t('activerecord.errors.models.expense.attributes.time.format'))
    end
    if time_end && !time_end.match(/\A(?:[0-1]?[0-9]|2[0-3]):[0-5][0-9]/)
      errors.add(:time_end, I18n.t('activerecord.errors.models.expense.attributes.time.format'))
    end
  end
end
