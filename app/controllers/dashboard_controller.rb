class DashboardController < ApplicationController
  def index
    @activities, @notifications = current_user.create_notification_arrays

    @ending_contracts = Contract.ends_soon.accessible_by(current_ability, :show)

    contracts = Contract.accessible_by(current_ability, :show)
    @missing_timesheets = DismissedMissingTimesheet.missing_for(current_user, contracts)
  end
end