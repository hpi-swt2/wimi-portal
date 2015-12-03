class HolidaysController < ApplicationController
  before_action :set_holiday, only: [:show, :edit, :update, :destroy]

  def index
    @holidays = Holiday.all
  end

  def show
  end

  def new
    @holiday = Holiday.new
  end

  def edit
  end

  def create
    @holiday = Holiday.new(holiday_params.merge(user_id: current_user.id))

    if @holiday.save
      subtract_leave
      flash[:success] = 'Holiday was successfully created.'
      redirect_to @holiday
    else
      render :new
    end
  end

  def update
    if @holiday.update(holiday_params)
      flash[:success] = 'Holiday was successfully updated.'
      redirect_to @holiday
    else
      render :edit
    end
  end

  def destroy
    if @holiday.end > Date.today
      add_leave
    end
    @holiday.destroy
    flash[:success] = 'Holiday was successfully destroyed.'
    redirect_to holidays_url
  end

  private
    def set_holiday
      @holiday = Holiday.find(params[:id])
    end

    def holiday_params
      params[:holiday].permit(Holiday.column_names.map(&:to_sym))
    end

    def calculate_leave(operator)
      current_user.update_attribute(:remaining_leave_this_year, current_user.remaining_leave_this_year.send(operator, @holiday.duration_this_year))
      current_user.update_attribute(:remaining_leave_next_year, current_user.remaining_leave_next_year.send(operator, @holiday.duration_next_year))
    end

    def add_leave
      calculate_leave(:+)
    end

    def subtract_leave
      calculate_leave(:-)
    end
end
