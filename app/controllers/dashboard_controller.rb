class DashboardController < ApplicationController
  def index
    @notifications = Event.select{|event| event.target == current_user && event.type == "EventProjectInvitation"}.reverse
    @notifications.concat(Event.select{|event| event.target == current_user && (event.type == "EventTimeSheetAccepted" || event.type == "EventTimeSheetDeclined")}.reverse)
    current_user.projects.each do |project|
      @notifications.concat(Event.select{|event| (event.target == project) && (event[:seclevel] >= Event.seclevel_of_user(current_user))})
      @notifications.concat(Event.select{|event| event.target == project && event[:seclevel] == Event.seclevel_of_user(current_user) && event.type == "EventTimeSheetSubmitted"})
    end
    @notifications = Array.new

    @notifications += Event.where(seclevel: Event.seclevels[:superadmin]) if current_user.is_superadmin?
    @notifications += Event.where(seclevel: Event.seclevels[:admin]) if current_user.is_admin?
    @notifications += Event.where(seclevel: Event.seclevels[:representative]) if current_user.is_representative?
    @notifications += Event.where(seclevel: Event.seclevels[:wimi]) if current_user.is_wimi?
    @notifications += Event.where(seclevel: Event.seclevels[:hiwi]) if current_user.is_hiwi?

    @notifications += Event.where(seclevel: Event.seclevels[:user])

    @notifications.delete_if { |event| event.chair_id != current_user.chair.id }
    @notifications.delete_if { |event| event.is_hidden_by(current_user) }
    @notifications = @notifications.sort_by { |n| n[:created_at] }.reverse

    @invitations = Invitation.where(user: current_user)
  end
end
