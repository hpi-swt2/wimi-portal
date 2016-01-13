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
      request_applied if @holiday.status == 'applied'
      subtract_leave
      flash[:success] = 'Holiday was successfully created.'
      redirect_to current_user
    else
      render :new
    end
  end

  def update
    status = @holiday.status
    if @holiday.update(holiday_params)
      request_applied if @holiday.status == 'applied' && status == 'saved'
      flash[:success] = 'Holiday was successfully updated.'
      redirect_to @holiday
    else
      render :edit
    end
  end

  def request_applied
    if current_user.chair
      ActiveSupport::Notifications.instrument('event', {trigger: current_user.id, target: @holiday.id, chair: current_user.chair, type: 'EventRequest', seclevel: :representative, status: 'holiday'})
    end
  end

  def destroy
    if @holiday.end > Date.today
      add_leave
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

  def calculate_leave(operator)
    current_user.update_attribute(:remaining_leave, current_user.remaining_leave.send(operator, @holiday.duration))
    current_user.update_attribute(:remaining_leave_last_year, current_user.remaining_leave_last_year.send(operator, @holiday.duration_last_year))
  end

  def add_leave
    calculate_leave(:+)
  end

  def subtract_leave
    calculate_leave(:-)
  end
end
