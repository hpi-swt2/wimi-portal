class DashboardController < ApplicationController
  def index
    @invitations = Invitation.where(user: current_user)
    @notifications = Event.select{|event| event.target == current_user}
  end
end
