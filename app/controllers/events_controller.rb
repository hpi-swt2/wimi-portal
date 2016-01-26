class EventsController < ActionController::Base
  before_action :set_event, only: [:hide]

  def hide
    @event.hide_for(current_user)
    redirect_to dashboard_path
  end

  def show_request
    status = params[:status]
    request_id = params[:request_id]

    path = case status
             when 'holiday' then
               holiday_path(id: request_id)
             when 'trip' then
               trip_path(id: request_id)
             when 'expense' then
               trip_path(id: Expense.find_by_id(request_id).trip.id)
             else
               dashboard_path
           end

    redirect_to path
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end
end
