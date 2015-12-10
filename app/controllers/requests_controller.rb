class RequestsController < ApplicationController
  before_action :set_chair, only: [:requests]

  def set_chair
    @chair = Chair.find(params[:id])
  end


  def requests
    @allrequests = Array.new

    @chair.users.each do |user|
      user.holidays.each do |holidays|
        @allrequests << {:name => holidays.user.name, :type => 'Holiday Request', :handed_in => holidays.created_at, :status => 'todo', :action =>  holiday_path(holidays)}
      end
      user.expenses.each do |expense|
        @allrequests << {:name => expense.user.name, :type => 'Expense Request', :handed_in  => expense.created_at, :status => 'todo', :action =>  expense_path(expense)}
      end
      user.trips.each do |trips|
        @allrequests << {:name => trips.user.name, :type => 'Trip Request', :handed_in  => trips.created_at, :status => 'todo', :action =>  trip_path(trips)}
        print trips_path(trips)
      end
    end
    @allrequests = @allrequests.sort_by{ | v | v[:handed_in] }.reverse
  end
end