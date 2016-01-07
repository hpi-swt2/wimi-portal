class DashboardController < ApplicationController
  def index
    @notifications = EventAdminRightsChanged.all
    @invitations = Invitation.where(user: current_user)
  end
end
