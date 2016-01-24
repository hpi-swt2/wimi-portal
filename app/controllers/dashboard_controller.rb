class DashboardController < ApplicationController
  def index
    @notifications = []
    @temp = []
    seclevel = Event.seclevel_of_user(current_user)

    @temp += Event.where(seclevel: Event.seclevels[:superadmin]) if current_user.is_superadmin?
    @temp += Event.where(seclevel: Event.seclevels[:admin]) if current_user.is_admin?
    @temp += Event.where(seclevel: Event.seclevels[:representative]) if current_user.is_representative?
    @temp += Event.where(seclevel: Event.seclevels[:wimi]) if current_user.is_wimi?
    @temp += Event.where(seclevel: Event.seclevels[:hiwi]) if current_user.is_hiwi?
    @temp += Event.where(seclevel: Event.seclevels[:user])

    @notifications += Event.select{|event| event.target_id == current_user.id && event.type == 'EventProjectInvitation'}
    @notifications += @temp.select{|event| event.target_id == current_user.id && (event.type == 'EventTimeSheetAccepted' || event.type == "EventTimeSheetDeclined")}
    current_user.projects.each do |project|
      @notifications += @temp.select{|event| event.target == project}
      @notifications += @temp.select{|event| event.target == project && event.type == "EventTimeSheetSubmitted"}
    end

    @notifications += @temp.select{|event| event.target_id == current_user.id && event.type == 'EventAdminRight'}
    @notifications += @temp.select{|event| event.chair == current_user.chair && event.type == 'EventChairApplication'}
    @notifications += @temp.select{|event| event.chair == current_user.chair && (event.status == 'holiday' || event.status == 'travel_expense_report' || event.status == 'trip') && event.type == 'EventRequest'}
    @notifications += @temp.select{|event| event.chair == current_user.chair && event.type == 'EventUserChair'}
    @notifications += @temp.select{|event| event.target_id == current_user.id && (event.type == 'EventTravelRequestAccepted' || event.type == 'EventTravelRequestDeclined')}

    #@notifications.delete_if { |event| event.chair_id != current_user.chair.id }
    #@notifications.delete_if { |event| event.is_hidden_by(current_user) }
    @notifications = @notifications.sort_by { |n| n[:created_at] }.reverse

    #@invitations = Invitation.where(user: current_user)
  end
end
