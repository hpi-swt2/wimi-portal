class ReportingController < ApplicationController

  before_action :prepare_chair, :parseParams

  def index
    render :layout => 'no_sidebar'
  end

  def data
    reporting_data = {
      data: @chair.reporting_for_year(@year),
      contractinfo: @chair.reporting_contract_info(@year),
      projectinfo: @chair.reporting_project_info(@year)
    };

    render json: reporting_data
  end

  private

  def prepare_chair
    @chair = Chair.find(params[:chair_id])
    authorize! :reporting, @chair
  end

  def parseParams
    @year = params[:year].to_i
    if not params[:year]
      @year = Date.today.year
    end
  end

end
