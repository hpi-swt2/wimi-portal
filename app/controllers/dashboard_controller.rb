class DashboardController < ApplicationController
  def index
    @invitations = Invitation.where(user: current_user)
    @applied_requests = collectAppliedRequests
  end

  def collectAppliedRequests
    requests = Array.new

    unless current_user.chair.nil?
      current_user.chair.users.each do |user|
        applied_holidays = user.holidays.select { |h| h.status == 'applied' }
        applied_holidays.each do |holiday|
          requests << {type: "holiday", handed_in: holiday.created_at, request: holiday}
        end

        applied_expenses = user.expenses.select { |e| e.status == 'applied' }
        applied_expenses.each do |expense|
          requests << {type: "expense", handed_in: expense.created_at, request: expense}
        end

        applied_trips = user.trips.select { |t| t.status == 'applied' }
        applied_trips.each do |trip|
          requests << {type: "trip", handed_in: trip.created_at, request: trip}
        end
      end

      requests = requests.sort_by { |r| r[:handed_in] }.reverse
    end

    return requests
  end
end
