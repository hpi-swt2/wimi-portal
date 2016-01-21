class TimeSheetsController < ApplicationController
  before_action :set_time_sheet, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @time_sheet = TimeSheet.new
  end

  def edit
  end

  def update
    if @time_sheet.update(time_sheet_params)
      flash[:success] = 'Time Sheet was successfully updated.'
      redirect_to work_days_path(month: @time_sheet.month, year: @time_sheet.year, project: @time_sheet.project)
    else
      render :edit
    end
  end

  private

  def set_time_sheet
    @time_sheet = TimeSheet.find(params[:id])
  end

  def time_sheet_params
    params.require(:time_sheet).permit(:month, :year, :salary, :salary_is_per_month, :workload, :workload_is_per_month, :user_id, :project_id)
  end
end
