class ReportingController < ApplicationController

  before_action :prepare_chair

  def index
    render :layout => 'no_sidebar'
  end

  private

  def prepare_chair
    @chair = Chair.find(params[:chair_id])
    authorize! :reporting, @chair
  end

end
