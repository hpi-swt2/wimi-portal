class RequestsController < ApplicationController
  before_action :set_chair, only: [:requests, :requests_filtered]
  before_action :authorize_representative, only: [:requests, :requests_filtered]


  def set_chair
    @chair = Chair.find(params[:id])
  end

  def requests
    @types = ['holidays', 'expenses', 'trips']
    @statuses = ['applied', 'accepted', 'declined']

    create_allrequests
  end

  def requests_filtered
    @types = Array.new
    @types << 'holidays' if params.has_key?('holiday_filter') 
    @types << 'expenses' if params.has_key?('expense_filter') 
    @types << 'trips' if params.has_key?('trip_filter')

    @statuses = Array.new
    @statuses << 'applied' if params.has_key?('applied_filter')
    @statuses << 'accepted' if params.has_key?('accepted_filter')
    @statuses << 'declined' if params.has_key?('declined_filter')

    create_allrequests
    render 'requests'
  end


  private
  def create_allrequests
    @allrequests = Array.new

    @chair.users.each do |user|
      add_requests('Holiday Request', user.holidays) if @types.include? 'holidays'
      add_requests('Expense Request', user.expenses) if @types.include? 'expenses'
      add_requests('Trip Request', user.trips) if @types.include? 'trips'
    end
    
    @allrequests = @allrequests.sort_by { |v| v[:handed_in] }.reverse
  end

  def add_requests(type, array)
    array.each do |r|
      if @statuses.include? r.status
        @allrequests << {name: r.user.name, type: type, handed_in: r.created_at, status: r.status, action: r}
      end
    end
  end

  def authorize_representative
    not_authorized unless current_user.is_representative?(@chair) 
  end

  def not_authorized
    redirect_to root_path, notice: 'Not authorized for this chair.'
  end
end