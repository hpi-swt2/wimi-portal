class DashboardController < ApplicationController
  def index
    @notifications = []
    @activities = []
    temp = []
    seclevel = Event.seclevel_of_user(current_user)

    temp += Event.where(seclevel: Event.seclevels[:superadmin]) if current_user.is_superadmin?
    temp += Event.where(seclevel: Event.seclevels[:admin]) if current_user.is_admin?
    temp += Event.where(seclevel: Event.seclevels[:representative]) if current_user.is_representative?
    temp += Event.where(seclevel: Event.seclevels[:wimi]) if current_user.is_wimi?
    temp += Event.where(seclevel: Event.seclevels[:hiwi]) if current_user.is_hiwi?
    temp += Event.where(seclevel: Event.seclevels[:user])

    @activities += Event.select{|event| event.target_id == current_user.id && event.type == 'EventProjectInvitation'}
    @activities += temp.select{|event| event.chair == current_user.chair && event.type == 'EventChairApplication'}
    @notifications += temp.select{|event| event.target_id == current_user.id && (event.type == 'EventTimeSheetAccepted' || event.type == "EventTimeSheetDeclined")}
    current_user.projects.each do |project|
      @notifications += temp.select{|event| event.target == project && event.type == "EventTimeSheetSubmitted"}
    end

    @notifications += temp.select{|event| event.target_id == current_user.id && event.type == 'EventAdminRight'}
    @notifications += temp.select{|event| event.chair == current_user.chair && (event.status == 'holiday' || event.status == 'travel_expense_report' || event.status == 'trip') && event.type == 'EventRequest'}
    @notifications += temp.select{|event| event.chair == current_user.chair && event.type == 'EventUserChair'}
    @notifications += temp.select{|event| event.target_id == current_user.id && (event.type == 'EventTravelRequestAccepted' || event.type == 'EventTravelRequestDeclined')}

    #@notifications.delete_if { |event| event.chair_id != current_user.chair.id }
    #@notifications.delete_if { |event| event.is_hidden_by(current_user) }
    @activities = @activities.sort_by { |n| n[:created_at] }.reverse
    @notifications = @notifications.sort_by { |n| n[:created_at] }.reverse
    to_delete = @notifications.drop(50)
    unless to_delete.empty?
      to_delete.delete_all
    end

    #@invitations = Invitation.where(user: current_user)
  end
end
