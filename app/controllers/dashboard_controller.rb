class DashboardController < ApplicationController
  def index
    @notifications = Event.select{|event| event.target == current_user}
    current_user.projects.each do |project|
      @notifications.concat(Event.select{|event| (event.target == project.id)})
    end
  end
end
