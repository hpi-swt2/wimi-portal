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
      # with year and month given, show only work days of one user
      @user = User.find_by(id: params[:user])
      unless @user
        contract = Contract.find_by(id: params[:contract])
        @user = contract ? contract.hiwi : current_user
      end
      @time_sheets = @user.time_sheets_for(@month, @year)
      if @time_sheets.empty?
        flash[:error] = t('helpers.flash.no_contract', month: @month, year: @year)
        @work_days = apply_scopes(@work_days).month(@month, @year)
      else
        @work_days = []
        @time_sheets.each do |ts|
          @work_days += ts.work_days if can? :show, ts
        end
      end
    else
      # show all work days that CanCan allows
      @work_days = apply_scopes(@work_days)
    end
    @work_days = @work_days.sort_by {|w| [w.date, w.start_time] }
    @project = Project.find_by(id: params[:project])
  end

  def show
    redirect_to work_days_month_project_path
  end

  def new
    @work_day.date = Date.today
    if params[:project]
      project = Project.find_by_id(params[:project])
      if project.blank? or !project.users.include? current_user
        flash[:notice] = t 'activerecord.errors.models.work_day.flash.not_member'
      else
        @work_day.project = project
      end
    end
  end

  def edit
  end

  def create
    @work_day = WorkDay.new(work_day_params)
    @work_day.user = current_user
    
    ts = @work_day.time_sheet
    authorize! :edit, ts if ts

    if @work_day.save
      flash[:success] = t('helpers.flash.created', model: @work_day.model_name.human.titleize)
      redirect_to work_days_month_project_path
    else
      render :new
    end
  end

  def update
    if @work_day.update(work_day_params)
      flash[:success] = t('helpers.flash.updated', model: @work_day.model_name.human.titleize)
      redirect_to work_days_month_project_path
    else
      render :edit
    end
  end

  def destroy
    date = @work_day.date
    @work_day.destroy
    flash[:success] = t('helpers.flash.destroyed', model: @work_day.model_name.human.titleize)
    redirect_to work_days_month_project_path
  end

  private

#  # Use callbacks to share common setup or constraints between actions.
#  def set_work_day
#    @work_day = WorkDay.find(params[:id])
#  end

  def work_day_params
    allowed_params = [:date, :start_time, :break, :end_time, :attendance, :notes, :user, :project_id]
    delocalize_config = { :date => :date }
    params.require(:work_day).permit(*allowed_params).delocalize(delocalize_config)
  end

  def work_days_month_project_path
    work_days_path(month: @work_day.date.month, year: @work_day.date.year, project: @work_day.project, user: @work_day.user)
  end
end
