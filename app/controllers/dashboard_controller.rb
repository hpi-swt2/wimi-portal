class DashboardController < ApplicationController
  def index
    @activities, @notifications = current_user.create_notification_arrays

    @ending_contracts = Contract.ends_soon.accessible_by(current_ability, :show)
    @ending_contracts.sort {|a,b| a.end_date <=> b.end_date }

    contracts = Contract.accessible_by(current_ability, :show)
    @missing_timesheets = DismissedMissingTimesheet.missing_for(current_user, contracts)
  end
end