class WorkDaysController < ApplicationController
  before_action :set_work_day, only: [:show, :edit, :update, :destroy]

  def index
    if params.has_key?(:month) && params.has_key?(:year)
      @month = params[:month].to_i
      @year = params[:year].to_i
      @project = params.has_key?(:project) ? Project.find(params[:project].to_i) : nil
      @time_sheet = time_sheet_for(@year, @month, @project)
      @work_days = all_for(@year, @month, @project)
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
    @work_day.user_id = current_user.id

    if @work_day.save
      redirect_to work_days_month_path
    else
      render :new
    end
  end

  def update
    if @work_day.update(work_day_params)
      redirect_to work_days_month_path
    else
      render :edit
    end
  end

  def destroy
    date = @work_day.date
    @work_day.destroy
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


    def all_for(year, month, project)
      date = Date.new(year, month)
      month_start = date.beginning_of_month
      month_end = date.end_of_month
      if project.nil?
        return WorkDay.where(date: month_start..month_end, user_id: current_user)
      else
        return WorkDay.where(date: month_start..month_end, user_id: current_user, project_id: project)
      end
    end

    def time_sheet_for(year, month, project)
      if project.nil?
        return nil
      else
        sheets = TimeSheet.where(year: year, month: month, project: project)
        if sheets.empty?
          return create_new_time_sheet(year, month, project)
        else
          return sheets.first
        end
      end
    end

    def create_new_time_sheet(year, month, project)
      sheet = TimeSheet.create!({year: year, month: month, project_id: project.id, user_id: current_user.id, workload_is_per_month: true, salary_is_per_month: true})
      sheet.save()
      return sheet
    end

    def work_days_month_path
        work_days_path(month: @work_day.date.month, year: @work_day.date.year)
    end
end
