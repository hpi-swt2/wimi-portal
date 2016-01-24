class DashboardController < ApplicationController
  def index
    @activities = []
    @notifications = []
    temp = []

    temp += Event.where(seclevel: Event.seclevels[:superadmin]) if current_user.is_superadmin?
    temp += Event.where(seclevel: Event.seclevels[:admin]) if current_user.is_admin?
    temp += Event.where(seclevel: Event.seclevels[:representative]) if current_user.is_representative?
    temp += Event.where(seclevel: Event.seclevels[:wimi]) if current_user.is_wimi?
    temp += Event.where(seclevel: Event.seclevels[:hiwi]) if current_user.is_hiwi?
    temp += Event.where(seclevel: Event.seclevels[:user])

    @notifications += Event.select{|event| event.target_id == current_user.id && event.type == 'EventProjectInvitation'}
    @notifications += temp.select{|event| event.chair == current_user.chair && event.type == 'EventChairApplication'}

    @notifications = @notifications.sort_by { |n| n[:created_at] }.reverse

    @activities += temp.select{|event| event.target_id == current_user.id && (event.type == 'EventTimeSheetAccepted' || event.type == "EventTimeSheetDeclined")}
    current_user.projects.each do |project|
      @activities += temp.select{|event| event.target == project && event.type == "EventTimeSheetSubmitted"}
    end
    @activities += temp.select{|event| event.target_id == current_user.id && event.type == 'EventAdminRight'}
    @activities += temp.select{|event| event.chair == current_user.chair && (event.status == 'holiday' || event.status == 'travel_expense_report' || event.status == 'trip') && event.type == 'EventRequest'}
    @activities += temp.select{|event| event.chair == current_user.chair && event.type == 'EventUserChair'}
    @activities += temp.select{|event| event.target_id == current_user.id && (event.type == 'EventTravelRequestAccepted' || event.type == 'EventTravelRequestDeclined')}

    @activities.delete_if { |event| event.is_hidden_by(current_user) }
    @activities = @activities.sort_by { |n| n[:created_at] }.reverse

    to_delete = @activities.drop(50)
    unless to_delete.empty?
      to_delete.delete_all
    end

    @activities = @activities.take(50)
  end
end
