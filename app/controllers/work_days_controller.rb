class WorkDaysController < ApplicationController
  before_action :set_work_day, only: [:show, :edit, :update, :destroy]

  def index
    if params.has_key?(:month) && params.has_key?(:year) && params.has_key?(:project) && params.has_key?(:user_id) && User.find_by_id(params[:user_id]) != nil
      @month = params[:month].to_i
      @year = params[:year].to_i
      @project = Project.find(params[:project].to_i)
      @user = User.find(params[:user_id])
      @time_sheet = TimeSheet.time_sheet_for(@year, @month, @project, @user)
      @work_days = WorkDay.all_for(@year, @month, @project, @user)
    else
      redirect_to user_path(current_user)
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
      redirect_to path_to_list_with_work_day(@work_day)
    else
      render :new
    end
  end

  def update
    if @work_day.update(work_day_params)
      flash[:success] = 'Work Day was successfully updated.'
      redirect_to path_to_list_with_work_day(@work_day)
    else
      render :edit
    end
  end

  def destroy
    old_work_day = @work_day
    @work_day.destroy
    flash[:success] = 'Work Day was successfully destroyed.'
    redirect_to path_to_list_with_work_day(old_work_day)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_work_day
    @work_day = WorkDay.find(params[:id])
  end

  def work_day_params
    params.require(:work_day).permit(:date, :start_time, :break, :end_time, :duration, :attendance, :notes, :user_id, :project_id)
  end

  def path_to_list_with_work_day(work_day)
    work_days_path(month: work_day.date.month, year: work_day.date.year, project: work_day.project_id, user_id: current_user)
  end
end
