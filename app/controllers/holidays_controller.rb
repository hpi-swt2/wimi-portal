class HolidaysController < ApplicationController
  before_action :set_holiday, only: [:show, :edit, :update, :destroy, :hand_in]

  def index
    @holidays = Holiday.all
  end

  def show
    unless can? :read, @holiday 
      redirect_to holidays_path
    end
  end

  def new
    @holiday = Holiday.new
  end

  def edit
  end

  def create
    if holiday_params['length'].blank?
      #disregard errors here, they should be handled in model validation later
      params['holiday']['length'] = holiday_params['start'].to_date.business_days_until(holiday_params['end'].to_date+1) rescue nil
    end
    @holiday = Holiday.new(holiday_params.merge(user_id: current_user.id, last_modified: Date.today))
    if @holiday.save
      subtract_leave(@holiday.length)
      flash[:success] = 'Holiday was successfully created.'
      redirect_to @holiday
    else
      render :new
    end
  end

  def update
    lengths = @holiday.calculate_length_difference(holiday_params['length'])
    params['holiday']['length'] = lengths[:length_difference]

    if @holiday.update(holiday_params)
      flash[:success] = 'Holiday was successfully updated.'
      @holiday.update(length: lengths[:new_length])
      subtract_leave(lengths[:length_difference])
      redirect_to @holiday
    else
      @holiday.update(length: lengths[:old_length])
      render :edit
    end
  end

  def hand_in
    if @holiday.status == 'saved'
      if @holiday.update(status: 'applied')
        ActiveSupport::Notifications.instrument('event', {trigger: current_user.id, target: @holiday.id, chair: current_user.chair, type: 'EventRequest', seclevel: :representative, status: 'holiday'})
      end
    end
    redirect_to holidays_path
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
end
