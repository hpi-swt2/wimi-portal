class DashboardController < ApplicationController
  def index
    result = current_user.create_notification_arrays
    
    @activities = result[0]
    @notifications = result[1]

    @ending_contracts = Contract.ends_soon.accessible_by(current_ability, :show)
    @ending_contracts.sort {|a,b| a.end_date <=> b.end_date }

    @missing_timesheets = Contract.accessible_by(current_ability, :show)
    @missing_timesheets = @missing_timesheets.collect{|c| c.missing_timesheets != [] ? [c.missing_timesheets,c] : nil}
    @missing_timesheets.compact!
  end
end
