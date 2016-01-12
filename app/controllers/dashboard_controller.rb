class DashboardController < ApplicationController
  def index
    @notifications = Event.select{|event| event.target == current_user && event.type == "EventProjectInvitation"}.reverse
    @notifications.concat(Event.select{|event| event.target == current_user && (event.type == "EventTimeSheetAccepted" || event.type == "EventTimeSheetDeclined")}.reverse)
    current_user.projects.each do |project|
      @notifications.concat(Event.select{|event| (event.target == project) && (event[:seclevel] >= Event.seclevel_of_user(current_user))})
      @notifications.concat(Event.select{|event| event.target == project && event[:seclevel] == Event.seclevel_of_user(current_user) && event.type == "EventTimeSheetSubmitted"})
    end
  end
end
