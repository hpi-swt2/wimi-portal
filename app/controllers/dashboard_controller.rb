class DashboardController < ApplicationController
  def index
    result = current_user.create_notification_arrays
    
    @activities = result[0]
    @notifications = result[1]   
  end
end
