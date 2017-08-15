class DashboardController < ApplicationController
  def index
    contracts = Contract.accessible_by(current_ability, :show)

    @ending_contracts = contracts.ends_soon

    @missing_timesheets = contracts.limit(50).map do |contract|
      missing = contract.missing_timesheets
      missing.present? ? [missing, contract] : nil
    end
    @missing_timesheets.compact!

    @events = Event.limit(25)
      .order(created_at: :desc)
      .select { |e| current_ability.can?(:show, e)}

    @own_contracts = current_user.contracts
  end
end