class DashboardController < ApplicationController
  def index
    @notifications = EventAdminRightsChanged.all
  end
end
