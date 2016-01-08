class DashboardController < ApplicationController
  def index
    @invitations = Invitation.where(user: current_user)
    @applied_requests = collectAplliedRequests
  end

  def collectAplliedRequests
    requests = Array.new

    current_user.chair.users.each do |user|
      applied_holidays = user.holidays.select { |h| h.status == 'applied' }
      applied_holidays.each do |holiday|
        requests << {type: "holiday", handed_in: holiday.created_at, request: holiday}
      end

      # applied_expense = user.expenses.select { |e| e.status == 'applied' }
      user.expenses.each do |expense|
        requests << {type: "expense", handed_in: expense.created_at, request: expense}
      end

      # applied_trip = user.trips.select { |t| t.status == 'applied' }
      user.trips.each do |trip|
        requests << {type: "trip", handed_in: trip.created_at, request: trip}
      end
    end

    requests = requests.sort_by { |r| r[:handed_in] }.reverse

    return requests
  end
end
