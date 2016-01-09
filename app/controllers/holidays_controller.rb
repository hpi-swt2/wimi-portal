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
    if holiday_params['length'] == "" || holiday_params['length'].nil?
      params['holiday']['length'] = holiday_params['start'].to_date.business_days_until(holiday_params['end'].to_date+1)
    end
    @holiday = Holiday.new(holiday_params.merge(user_id: current_user.id))
    if @holiday.save
      subtract_leave(@holiday.length)
      flash[:success] = 'Holiday was successfully created.'
      redirect_to current_user
    else
      render :new
    end
  end

  def update
    calculate_length_difference
    if @holiday.update(holiday_params)
      flash[:success] = 'Holiday was successfully updated.'
      @holiday.update_attribute(:length, @new_length.to_i)
      subtract_leave(@length_difference)
      redirect_to @holiday
    else
      @holiday.update_attribute(:length, @old_length)
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

  private
    def set_holiday
      @holiday = Holiday.find(params[:id])
    end

    def holiday_params
      params[:holiday].permit(Holiday.column_names.map(&:to_sym))
    end

    def calculate_leave(operator, length)
      length_last_year = (current_user.remaining_leave_last_year - length > 0) ? (current_user.remaining_leave_last_year - length) : current_user.remaining_leave_last_year
      current_user.update_attribute(:remaining_leave_last_year, current_user.remaining_leave_last_year.send(operator, length_last_year))
      current_user.update_attribute(:remaining_leave, current_user.remaining_leave.send(operator, length))
    end

    def add_leave(length)
      calculate_leave(:+, length)
    end

    def subtract_leave(length)
      calculate_leave(:-, length)
    end

    def calculate_length_difference
      @old_length = @holiday.length.nil? ? 0 : @holiday.length
      @new_length = holiday_params['length']

      unless @new_length == "" || @new_length.nil?
        @length_difference = @new_length.to_i - @old_length
      else
        @new_length = @holiday.duration
        @length_difference = @holiday.duration - @old_length
      end

      params['holiday']['length'] = @length_difference
    end
end
