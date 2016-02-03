class DashboardController < ApplicationController
  def index
    #activities are events you dont necessarily need to react to
    # => get destroyed if they're not under the newest 50
    #notifications are events you need to react to
    # => get destroyed when you react to them
    @activities = []
    @notifications = []

    # Chair-Applications: apply
    @notifications += Event.where(chair: current_user.chair).where(type: 'EventChairApplication') if current_user.is_admin?

    # Chair-Applications: accept
    @activities += Event.where(target_id: current_user.id).where(type: 'EventUserChair').where(status: 'added')
    @activities += Event.where(chair: current_user.chair).where(type: 'EventUserChair').where(status: 'added') if current_user.is_wimi?

    # Chair-Applications: decline
    @activities += Event.where(target_id: current_user.id).where(type: 'EventUserChair').where(status: 'declined')
    @activities += Event.where(chair: current_user.chair).where(type: 'EventUserChair').where(status: 'declined') if current_user.is_admin?

    # Chair-Applications: remove
    @activities += Event.where(target_id: current_user.id).where(type: 'EventUserChair').where(status: 'removed')
    @activities += Event.where(chair: current_user.chair).where(type: 'EventUserChair').where(status: 'removed') if current_user.is_wimi?

    # Chair-Admins: granted
    @activities += Event.where(target_id: current_user.id).where(type: 'EventAdminRight').where(status: 'added')
    @activities += Event.where(chair: current_user.chair).where(type: 'EventAdminRight').where(status: 'added') if current_user.is_admin?

    # Chair-Admins: granted
    @activities += Event.where(target_id: current_user.id).where(type: 'EventAdminRight').where(status: 'removed')
    @activities += Event.where(chair: current_user.chair).where(type: 'EventAdminRight').where(status: 'removed') if current_user.is_admin?

    # Holiday-/Trip-/Expense-Requests
    @activities += Event.where(trigger_id: current_user.id).where(type: 'EventRequest')
    @notifications += Event.where(chair: current_user.chair).where(type: 'EventRequest') if current_user.is_representative?

    @activities += Event.where(target_id: current_user.id).where(type: 'EventTravelRequestAccepted')
    @activities += Event.where(target_id: current_user.id).where(type: 'EventTravelRequestDeclined')

    # Holiday-Requests: accepted / declined
    @activities += Event.where(chair: current_user.chair).where(type: 'EventHolidayRequest') if current_user.is_representative?
    @activities += Event.where(target_id: current_user.id).where(type: 'EventHolidayRequest')


    




    #@notifications += Event.select{|event| event.target_id == current_user.id && event.type == 'EventProjectInvitation'}
    #@notifications += temp.select{|event| event.chair == current_user.chair && event.type == 'EventChairApplication'}

    #@notifications = @notifications.sort_by { |n| n[:created_at] }.reverse

    #@activities += temp.select{|event| event.target_id == current_user.id && (event.type == 'EventTimeSheetAccepted' || event.type == 'EventTimeSheetDeclined')}
    #current_user.projects.each do |project|
    #  @activities += temp.select{|event| event.target_id == project.id && event.type == 'EventTimeSheetSubmitted'}
    #end
    #@activities += temp.select{|event| event.target_id == current_user.id && event.type == 'EventAdminRight'}
    #@activities += temp.select{|event| event.chair == current_user.chair && (event.status == 'holiday' || event.status == 'travel_expense_report' || event.status == 'trip') && event.type == 'EventRequest'}
    #@activities += temp.select{|event| event.chair == current_user.chair && event.type == 'EventUserChair'}
    #@activities += temp.select{|event| event.target_id == current_user.id && (event.type == 'EventTravelRequestAccepted' || event.type == 'EventTravelRequestDeclined')}

    #@activities.delete_if { |event| event.is_hidden_by(current_user) }

    @notifications = @notifications.uniq.sort_by { |n| n[:created_at] }.reverse
    @activities = @activities.uniq.sort_by { |n| n[:created_at] }.reverse

    to_delete = @activities.drop(50)
    to_delete.each(&:destroy!)

    @activities = @activities.take(50)
  end
end
