class DashboardController < ApplicationController
  def index
    @notifications = Event.select{|event| event.target == current_user}
  end
end
