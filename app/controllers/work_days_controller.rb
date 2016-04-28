class WorkDaysController < ApplicationController
  before_action :set_work_day, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = t('not_authorized')
    redirect_to dashboard_path
  end

  def index
    if params.has_key?(:project)
      @month = params[:month].to_i # equals 0 when no month passed
      @year = params[:year].to_i # equals 0 when no month passed
      @user = params.has_key?(:user_id) && User.find_by_id(params[:user_id]) != nil ? User.find(params[:user_id]) : current_user
      @project = Project.find_by_id(params[:project].to_i)
      if @user.projects.find_by_id(@project.id) == nil
        redirect_to user_path(current_user, anchor: 'timesheets')
      end
      if @year != 0 && @month != 0
        @time_sheet = TimeSheet.time_sheet_for(@year, @month, @project, @user)
        if current_user != @user && !@time_sheet.handed_in?
          redirect_to user_path(@user)
        end
      end
      @work_days = WorkDay.all_for(@year, @month, @project, @user)
      # Sort first by date, then by start time
      @work_days = @work_days.sort_by {|w| [w.date, w.start_time] }
    else
      redirect_to user_path(current_user, anchor: 'timesheets')
    end
  end

  def show
    redirect_to work_days_month_project_path
  end

  def new
    @work_day = WorkDay.new
    @work_day.date = Date.today
  end

  def edit
  end

  def create
    @work_day = WorkDay.new(work_day_params)
    @work_day.user = current_user

    if @work_day.save
      flash[:success] = 'Work Day was successfully created.'
      redirect_to work_days_month_project_path
    else
      render :new
    end
  end

  def update
    if @work_day.update(work_day_params)
      flash[:success] = 'Work Day was successfully updated.'
      redirect_to work_days_month_project_path
    else
      render :edit
    end
  end

  def destroy
    date = @work_day.date
    @work_day.destroy
    flash[:success] = 'Work Day was successfully destroyed.'
    redirect_to work_days_month_project_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_work_day
    @work_day = WorkDay.find(params[:id])
  end

  def work_day_params
    allowed_params = [:date, :start_time, :break, :end_time, :duration, :attendance, :notes, :user_id, :project_id]
    delocalize_config = { :date => :date }
    params.require(:work_day).permit(*allowed_params).delocalize(delocalize_config)
  end

  def work_days_month_project_path
    work_days_path(month: @work_day.date.month, year: @work_day.date.year, project: @work_day.project.id, user_id: @work_day.user.id)
  end
end
