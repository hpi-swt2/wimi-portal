class DashboardController < ApplicationController
  def index
    @notifications = Event.select{|event| event.target == current_user}
    current_user.projects.each do |project|
      @notifications.concat(Event.select{|event| (event.target == project) && (event[:seclevel] >= event.seclevel_of_user(current_user))})
    end
  end
end
