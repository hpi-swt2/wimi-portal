class ReportingController < ApplicationController

  before_action :prepare_chair

  def index
    render :layout => 'no_sidebar'
  end

  def data
    render json: 
      @chair.work_days
      .group_by {|w| [w.project.name, w.month_year]}
      .map {| (p, m), w | {project: p, month:m, work_minutes:w.sum(&:duration_in_minutes)} }
  end

  private

  def prepare_chair
    @chair = Chair.find(params[:chair_id])
    authorize! :reporting, @chair
  end

end
