class HolidaysController < ApplicationController
  before_action :set_holiday, only: [:show, :edit, :update, :destroy]

  def index
    @holidays = Holiday.all
  end

  def show
    unless Holiday.find(params[:id]).user_id == current_user.id
      redirect_to holidays_path
    end
  end

  def new
    @holiday = Holiday.new
  end

  def edit
  end

  def create 
    @holiday = Holiday.new(holiday_params.merge(user_id: current_user.id))
    if @holiday.save
      @holiday.update_attribute(:length, @holiday.duration)
      subtract_leave(@holiday.length)
      flash[:success] = 'Holiday was successfully created.'
      redirect_to current_user
    else
      render :new
    end
  end

  def update
      old_length = holiday_params.length
    if @holiday.update(holiday_params)
      flash[:success] = 'Holiday was successfully updated.'
      raise
      add_leave(old_length.to_i-holiday_params.length.to_i)
      redirect_to @holiday
    else
      render :edit
    end
  end

  def destroy
    if @holiday.end > Date.today
      add_leave(@holiday.length)
    end
    @holiday.destroy
    flash[:success] = 'Holiday was successfully destroyed.'
    redirect_to holidays_path
  end

  def duration(startdate, enddate)
    startdate.business_days_until(enddate+1)
  end

  private
    def set_holiday
      @holiday = Holiday.find(params[:id])
    end

    def holiday_params
      params[:holiday].permit(Holiday.column_names.map(&:to_sym))
    end

    def calculate_leave(operator, length)
      current_user.update_attribute(:remaining_leave, current_user.remaining_leave.send(operator, length))
      current_user.update_attribute(:remaining_leave_last_year, current_user.remaining_leave_last_year.send(operator, @holiday.duration_last_year))
    end

    def add_leave(length)
      calculate_leave(:+, length)
    end

    def subtract_leave(length)
      calculate_leave(:-, length)
    end
end
