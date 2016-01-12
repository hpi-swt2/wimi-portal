class EventsController < ActionController::Base
  before_action :set_event

  def hide
    @event.hide_for(current_user)
    redirect_to dashboard_path
  end
  
  def unhide
    @event.unhide_for(current_user)
    redirect_to dashboard_path
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end
end
