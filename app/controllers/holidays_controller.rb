class HolidaysController < ApplicationController
  before_action :set_holiday, only: [:show, :edit, :update, :destroy, :file, :reject, :accept]

  def index
    @holidays = Holiday.all
  end

  def show
    unless (@holiday.user_id == current_user.id) || ((can? :see_holidays, @holiday.user) && (can? :judge_holiday, @holiday))
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
    parse_date
    if holiday_params['length'].blank?
      #disregard errors here, they should be handled in model validation later
      params['holiday']['length'] = holiday_params['start'].to_date.business_days_until(holiday_params['end'].to_date+1) rescue nil
    end
    @holiday = Holiday.new(holiday_params.merge(user_id: current_user.id, last_modified: Date.today))
    if @holiday.save
      flash[:success] = t('holiday.created')
      redirect_to @holiday
    else
      render :new
    end
  end

  def update
    parse_date
    lengths = @holiday.calculate_length_difference(holiday_params['length'])
    params['holiday']['length'] = lengths[:length_difference]

    if @holiday.update(holiday_params)
      flash[:success] = t('holiday.updated')
      @holiday.update(length: lengths[:new_length])
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
    flash[:success] = t('holiday.destroyed')
    redirect_to holidays_path
  end

  def file
    if ((@holiday.status.include? 'saved') || (@holiday.status.include? 'declined')) && @holiday.user = current_user
      if subtract_leave(@holiday.length)
        @holiday.update_attribute(:status, 'applied')
        @holiday.update_attribute(:last_modified, Date.today)
        redirect_to @holiday.user
      else
        redirect_to @holiday
        flash[:error] = t('holiday.not_enough_leave')
      end
    else
      redirect_to root_path
      flash[:error] = t('holiday.not_authorized')
    end
  end

  def reject
    if (can? :judge_holiday, @holiday) && @holiday.status == 'applied'
      if add_leave(@holiday.length)
        @holiday.update_attribute(:status, 'declined')
        @holiday.update_attribute(:last_modified, Date.today)
        redirect_to @holiday.user
      else
        redirect_to @holiday
        flash[:error] = t('holiday.something_wrong')
      end
    else
      redirect_to root_path
      flash[:error] = t('holiday.not_authorized')
    end
  end

  def accept
    if(can? :judge_holiday, @holiday) && @holiday.status == 'applied'
      @holiday.update_attribute(:status, 'accepted')
      @holiday.update_attribute(:last_modified, Date.today)
      redirect_to @holiday.user
    else
      redirect_to root_path
      flash[:error] = t('holiday.not_authorized')
    end
  end

  private

  def set_holiday
    @holiday = Holiday.find(params[:id])
  end

  def holiday_params
    params[:holiday].permit(Holiday.column_names.map(&:to_sym))
  end

  def calculate_leave(operator, length)
    length_last_year = (@holiday.user.remaining_leave_last_year.send(operator, length) > 0) ? (@holiday.user.remaining_leave_last_year.send(operator, length)) : 0
    @holiday.user.update_attribute(:remaining_leave_last_year, length_last_year)
    @holiday.user.update_attribute(:remaining_leave, @holiday.user.remaining_leave.send(operator, length))
  end

  def add_leave(length)
    updated_remaining_leave_last_year = @holiday.user.remaining_leave_last_year + @holiday.length_last_year
    user = @holiday.user
    user.update_attributes(remaining_leave_last_year: updated_remaining_leave_last_year, remaining_leave: @holiday.user.remaining_leave + length)
    user.valid?
  end

  def subtract_leave(length)
    length_last_year = (@holiday.user.remaining_leave_last_year - length >= 0) ? length : (@holiday.user.remaining_leave_last_year)
    @holiday.update(length_last_year: length_last_year)
    user = @holiday.user
    user.update_attributes(remaining_leave_last_year: @holiday.user.remaining_leave_last_year - @holiday.length_last_year, remaining_leave: @holiday.user.remaining_leave - length)
    user.valid?
  end

  def parse_date
    params['holiday']['start'] = Date.strptime(params['holiday']['start'], t('date.formats.default'))
    params['holiday']['end'] = Date.strptime(params['holiday']['end'], t('date.formats.default'))
  end
end
