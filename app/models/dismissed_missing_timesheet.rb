class DismissedMissingTimesheet < ActiveRecord::Base
  scope :user, -> user { where(user: user)}
  scope :dates_for, -> user, contract { where(user:user, contract: contract).collect{|entry| entry.month} }

  belongs_to :user
  belongs_to :contract

  validates :user, :contract, presence: true

  def self.missing_for(user, contracts)
    missing_ts = contracts.collect do |contract|
      missing = contract.missing_timesheets
      dismissed = self.dates_for(user, contract)
      missing = missing.select{|date| !dismissed.include?(date)}
      if user.missing_ts_last_month_only
        last_month = Date.today << 1
        missing = missing.select { |date| date.year == last_month.year and date.month == last_month.month }
      end
      missing != [] ? [missing, contract] : nil
    end
    return missing_ts.compact
  end
end
