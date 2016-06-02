class WorkDaysController < ApplicationController
  
  load_and_authorize_resource # only: [:index, :show, :edit, :update, :destroy]
  
#  has_scope :month
#  has_scope :year
  has_scope :user
  has_scope :project
  
  rescue_from CanCan::AccessDenied do |_exception|
    p _exception
    flash[:error] = t('not_authorized')
    redirect_to dashboard_path
  end

  def index
    @month = params[:month].to_i # equals 0 when no month passed
    @year = params[:year].to_i # equals 0 when no month passed
    if @year != 0 && @month != 0
      user = User.find_by(id: params[:user])
      unless user
        contract = Contract.find_by(id: params[:contract])
        user = contract ? contract.hiwi : current_user
      end
      @time_sheet = user.time_sheet(@month, @year)
      if @time_sheet
        authorize! :show, @time_sheet
        @work_days = @time_sheet.work_days
      else
        flash[:error] = "No contract for #@year/#@month"
        @work_days = apply_scopes(@work_days).month(@month, @year)
      end
    else
      @work_days = apply_scopes(@work_days)
    end
    @work_days = @work_days.sort_by {|w| [w.date, w.start_time] }
    @project = Project.find_by(id: params[:project])
#    @user = params.has_key?(:user_id) && User.find_by_id(params[:user_id]) != nil ? User.find(params[:user_id]) : current_user
#    @month = params[:month].to_i # equals 0 when no month passed
#    @year = params[:year].to_i # equals 0 when no month passed
#    if @year != 0 && @month != 0
#      @time_sheet = TimeSheet.time_sheet_for(@year, @month, @project, @user)
#      if current_user != @user && !@time_sheet.handed_in?
#        redirect_to user_path(@user)
#      end
#    end
#    @work_days = WorkDay.all_for(@year, @month, @project, @user)
#    # Sort first by date, then by start time
#    @work_days = @work_days.sort_by {|w| [w.date, w.start_time] }
  end

  def show
    redirect_to work_days_month_project_path
  end

  def new
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

#  # Use callbacks to share common setup or constraints between actions.
#  def set_work_day
#    @work_day = WorkDay.find(params[:id])
#  end

  def work_day_params
    allowed_params = [:date, :start_time, :break, :end_time, :attendance, :notes, :user, :project]
    delocalize_config = { :date => :date }
    params.require(:work_day).permit(*allowed_params).delocalize(delocalize_config)
  end

  def work_days_month_project_path
    work_days_path(month: @work_day.date.month, year: @work_day.date.year, project: @work_day.project, user: @work_day.user)
  end
end
