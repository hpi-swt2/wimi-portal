class WorkDaysController < ApplicationController
  before_action :set_work_day, only: [:show, :edit, :update, :destroy]

  # GET /work_days
  # GET /work_days.json
  def index
    month = params[:month].to_i
    year = params[:year].to_i
    @work_days = all_for(year, month)
  end

  # GET /work_days/1
  # GET /work_days/1.json
  def show
  end

  # GET /work_days/new
  def new
    @work_day = WorkDay.new
  end

  # GET /work_days/1/edit
  def edit
  end

  # POST /work_days
  # POST /work_days.json
  def create
    @work_day = WorkDay.new(work_day_params)
    @work_day.user_id = current_user.id

    respond_to do |format|
      if @work_day.save
        format.html { redirect_to work_days_month_path }
        format.json { render :show, status: :created, location: @work_day }
      else
        format.html { render :new }
        format.json { render json: @work_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /work_days/1
  # PATCH/PUT /work_days/1.json
  def update
    respond_to do |format|
      if @work_day.update(work_day_params)
        format.html { redirect_to work_days_month_path }
        format.json { render :show, status: :ok, location: @work_day }
      else
        format.html { render :edit }
        format.json { render json: @work_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_days/1
  # DELETE /work_days/1.json
  def destroy
    month = @work_day.work_month
    @work_day.destroy
    respond_to do |format|
      format.html { redirect_to month }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_day
      @work_day = WorkDay.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def work_day_params
      params.require(:work_day).permit(:date, :start_time, :brake, :end_time, :duration, :attendance, :notes, :user_id)
    end

    def all_for(year, month)
        date = Date.new(year, month)
        month_start = date.beginning_of_month
        month_end = date.end_of_month
        WorkDay.where("date >= ? and date <= ? and user_id = ?",
            month_start, month_end, current_user)
    end

    def work_days_month_path
        work_days_path(month: @work_day.date.month, year: @work_day.date.year)
    end
end
