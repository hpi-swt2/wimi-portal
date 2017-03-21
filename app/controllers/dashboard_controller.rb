class DashboardController < ApplicationController
  def index
    @ending_contracts = Contract.ends_soon.accessible_by(current_ability, :show)

    contracts = Contract.accessible_by(current_ability, :show)
    @missing_timesheets = DismissedMissingTimesheet.missing_for(current_user, contracts)

    @events = Event.all.select { |event| current_ability.can?(:show , event)}
  end
end