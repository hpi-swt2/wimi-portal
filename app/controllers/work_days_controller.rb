class WorkDaysController < ApplicationController
  before_action :set_work_day, only: [:show, :edit, :update, :destroy]

  def index
    if params.has_key?(:month) && params.has_key?(:year)
      @month = params[:month].to_i
      @year = params[:year].to_i
      @project = params.has_key?(:project) ? Project.find(params[:project].to_i) : nil
      @time_sheet = TimeSheet.time_sheet_for(@year, @month, @project, current_user)
      @work_days = WorkDay.all_for(@year, @month, @project, current_user)
    else
      date = Date.today
      redirect_to work_days_path(month: date.month, year: date.year)
    end
  end

  def show
  end

  def new
    @work_day = WorkDay.new
  end

  def edit
  end

  def create
    @work_day = WorkDay.new(work_day_params)
    @work_day.user = current_user

    if @work_day.save
      flash[:success] = 'Work Day was successfully created.'
      redirect_to work_days_month_path
    else
      render :new
    end
  end

  def update
    if @work_day.update(work_day_params)
      flash[:success] = 'Work Day was successfully updated.'
      redirect_to work_days_month_path
    else
      render :edit
    end
  end

  def destroy
    date = @work_day.date
    @work_day.destroy
    flash[:success] = 'Work Day was successfully destroyed.'
    redirect_to work_days_path(month: date.month, year: date.year)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_work_day
    @work_day = WorkDay.find(params[:id])
  end

  def work_day_params
    params.require(:work_day).permit(:date, :start_time, :break, :end_time, :duration, :attendance, :notes, :user_id, :project_id)
  end

  def work_days_month_path
    work_days_path(month: @work_day.date.month, year: @work_day.date.year)
  end
end
