class RequestsController < ApplicationController
  before_action :set_chair, only: [:requests]
  before_action :authorize_representative, only: [:requests]


  def set_chair
    @chair = Chair.find(params[:id])
  end


  def requests
    @allrequests = Array.new

    @chair.users.each do |user|
      user.holidays.each do |holidays|
        unless holidays.status == 'saved'
          @allrequests << {:name => holidays.user.name, :type => 'Holiday Request', :handed_in => holidays.created_at, :status => holidays.status, :action => holiday_path(holidays)}
        end
      end
      user.expenses.each do |expense|
        unless expense.status == 'saved'
          @allrequests << {:name => expense.user.name, :type => 'Expense Request', :handed_in => expense.created_at, :status => expense.status, :action => expense_path(expense)}
        end
      end
      user.trips.each do |trips|
        unless trips.status == 'saved'
          @allrequests << {:name => trips.user.name, :type => 'Trip Request', :handed_in => trips.created_at, :status => trips.status, :action => trip_path(trips)}
        end
      end
    end
    @allrequests = @allrequests.sort_by { |v| v[:handed_in] }.reverse
  end


  private
  def authorize_representative
    not_authorized unless current_user.is_representative?(@chair) 
  end

  def not_authorized
    redirect_to root_path, notice: 'Not authorized for this chair.'
  end
end