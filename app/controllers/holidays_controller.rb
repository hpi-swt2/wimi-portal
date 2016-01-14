class HolidaysController < ApplicationController
  before_action :set_holiday, only: [:show, :edit, :update, :destroy]

  def index
    @holidays = Holiday.all
  end

  def show
    unless (@holiday.user_id == current_user.id) || ((can? :show_holidays, @holiday.user) && (can? :edit_holiday, @holiday))
      redirect_to root_path
      flash[:error] = I18n.t('holiday.not_authorized')
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

  def destroy
    if @holiday.end > Date.today
      add_leave(@holiday.length)
    end
    @holiday.destroy
    flash[:success] = 'Holiday was successfully destroyed.'
    redirect_to holidays_path
  end

  def file
    holiday = Holiday.find(params[:id])
    holiday.update_attribute(:status, 'applied')
    holiday.update_attribute(:last_modified, Date.today)
    redirect_to Holiday.find(params[:id])
  end

  def reject
    holiday = Holiday.find(params[:id])
    holiday.update_attribute(:status, 'declined')
    holiday.update_attribute(:last_modified, Date.today)
    redirect_to Holiday.find(params[:id])
  end

  def accept
    holiday = Holiday.find(params[:id])
    holiday.update_attribute(:status, 'accepted')
    holiday.update_attribute(:last_modified, Date.today)
    redirect_to Holiday.find(params[:id])
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
