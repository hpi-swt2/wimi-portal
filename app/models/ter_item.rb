class TerItem < ActiveRecord::Base
  belongs_to :travel_expense_report
  validates :amount, presence: true

  def amount_greater_than_zero
    if amount <= 0
      errors.add(:amount, "must be greater than zero")
    end
  end
end
