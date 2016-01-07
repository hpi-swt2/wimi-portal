class DashboardController < ApplicationController
  def index
    @invitations = Invitation.where(user: current_user)
  end
end
