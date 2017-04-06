class DashboardController < ApplicationController
  def index
    @ending_contracts = Contract.ends_soon.accessible_by(current_ability, :show)

    contracts = Contract.accessible_by(current_ability, :show)

    @missing_timesheets = contracts.collect do |contract|
      missing = contract.missing_timesheets
      missing != [] ? [missing, contract] : nil
    end
    @missing_timesheets.compact!

    @events = Event.limit(50)
      .order(created_at: :desc)
      .select { |e| current_ability.can?(:show, e)}

    @own_contracts = current_user.contracts
  end
end