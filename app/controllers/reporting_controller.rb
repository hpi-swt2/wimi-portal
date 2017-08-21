class ReportingController < ApplicationController

  before_action :prepare_chair

  def index
    render :layout => 'no_sidebar'
  end

  def data
    all_months = []
    date = Date.today.at_beginning_of_year
    while date < Date.today.at_end_of_year
      all_months << date
      date >>= 1
    end

  #  render json: 
  #     Hash[Hash[@chair.work_days
  #     .group_by {|w| w.project.name}
  #     .map { |p, w| [p,w.group_by{ |w| w.date.at_beginning_of_month } ]}]
  #     .map { |p, h| [p, 
  #       all_months.map do |month|
  #         if h.include? month
  #           h[month].sum(&:salary)
  #         else
  #           0
  #         end
  #       end
  #     ] }]
    render json: @chair.reporting_for_year(Date.today.year)
      

  end

  private

  def prepare_chair
    @chair = Chair.find(params[:chair_id])
    authorize! :reporting, @chair
  end

end
