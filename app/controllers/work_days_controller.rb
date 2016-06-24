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
    # raises ActiveRecord::RecordNotFound
    @user = params[:user] ? User.find(params[:user]) : current_user
    # If month and year are not passed as URL params, use current date
    @month = params[:month] ? params[:month].to_i : Date.today.month
    @year = params[:year] ? params[:year].to_i : Date.today.year
    if not Ability.new(current_user).can? :index_all, WorkDay and @user != current_user
      raise CanCan::AccessDenied
    end
    @work_days = WorkDay.month(@month, @year).user(@user)
    @work_days = @work_days.sort_by {|w| [w.date, w.start_time] }
    @project = Project.find_by(id: params[:project])
    @time_sheets = @user.time_sheets_for(@month, @year)
    # Include prev and next month for building links
    @selected_date = Date.new(@year, @month)
    @prev_month = @selected_date - 1.month
    @next_month = @selected_date + 1.month
    if @time_sheets.blank? and not @work_days.blank?
      flash[:error] = t('helpers.flash.no_contract', user: @user.name, month: @month, year: @year)
    end
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
      flash[:success] = t('helpers.flash.created', model: @work_day.to_s.titleize)
      redirect_to work_days_month_path
    else
      render :new
    end
  end

  def update
    if @work_day.update(work_day_params)
      flash[:success] = t('helpers.flash.updated', model: @work_day.to_s.titleize)
      redirect_to work_days_month_path
    else
      render :edit
    end
  end

  def destroy
    date = @work_day.date
    @work_day.destroy
    flash[:success] = t('helpers.flash.destroyed', model: @work_day.to_s.titleize)
    redirect_to work_days_month_path
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

  def work_days_month_path
    work_days_path(month: @work_day.date.month, year: @work_day.date.year, user: @work_day.user)
  end
end
