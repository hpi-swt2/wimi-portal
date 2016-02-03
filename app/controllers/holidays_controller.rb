class HolidaysController < ApplicationController
  load_and_authorize_resource

  before_action :set_holiday, only: [:show, :edit, :update, :destroy, :file, :reject, :accept, :accept_reject]
  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = t('not_authorized')
    redirect_to root_path
  end

  def index
    @holidays = Holiday.all
    redirect_to user_path(current_user, anchor: 'holidays')
  end

  def show
  end

  def new
    @holiday = Holiday.new
  end

  def edit
    if @holiday.status == 'applied'
      redirect_to @holiday
      flash[:error] = I18n.t('holiday.applied')
    end
  end

  def create
    parse_date
    if holiday_params['length'].blank?
      #disregard errors here, they should be handled in model validation later
      params['holiday']['length'] = holiday_params['start'].to_date.business_days_until(holiday_params['end'].to_date + 1) rescue nil
    end
    @holiday = Holiday.new(holiday_params.merge(user: current_user, last_modified: Date.today))
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
    unless holiday_params['length'].to_i < 0
      params['holiday']['length'] = lengths[:length_difference]
    end

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
    if @holiday.status == 'applied'
      redirect_to @holiday
      flash[:error] = I18n.t('holiday.applied')
    else
      if @holiday.end > Date.today
        add_leave(@holiday.length)
      end
      @holiday.destroy
      flash[:success] = t('holiday.destroyed')
      redirect_to holidays_path
    end
  end

  def file
    if (@holiday.status == 'saved' || @holiday.status == 'declined')  && @holiday.user = current_user
      if subtract_leave(@holiday.length)
        @holiday.update_attribute(:status, 'applied')
        @holiday.update_attribute(:last_modified, Date.today)
        ActiveSupport::Notifications.instrument('event', {trigger: current_user.id, target: @holiday.id, chair: current_user.chair, type: 'EventRequest', seclevel: :representative, status: 'holiday'})
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
    if (can? :read, @holiday) && @holiday.status == 'applied'
      add_leave(@holiday.length)
      @holiday.update_attribute(:status, 'declined')
      @holiday.update_attribute(:last_modified, Date.today)
      redirect_to @holiday.user
    else
      redirect_to root_path
      flash[:error] = t('holiday.not_authorized')
    end
  end

  def accept
    if (can? :read, @holiday) && @holiday.status == 'applied'
      @holiday.update_attribute(:status, 'accepted')
      @holiday.update_attribute(:last_modified, Date.today)
      redirect_to @holiday.user
    else
      redirect_to root_path
      flash[:error] = t('holiday.not_authorized')
    end
  end

  def accept_reject
    if params[:commit] == t('holidays.show.reject')
      @holiday.update(holiday_params)
      reject
    else
      accept
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
    @holiday.user.update_attributes(remaining_leave_last_year: updated_remaining_leave_last_year, remaining_leave: @holiday.user.remaining_leave + length)
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
