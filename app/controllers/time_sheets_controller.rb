class TimeSheetsController < ApplicationController
#  before_action :set_time_sheet, only: [:show, :edit, :update, :destroy, :accept_reject, :hand_in]

  load_and_authorize_resource
  skip_authorize_resource only: [:download, :create, :current, :create_for_month_year]
  
  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = t('not_authorized')
    redirect_to dashboard_path
  end

  def show
    set_time_sheet
    set_projects
    next_date = @time_sheet.next_date
    @next_month = TimeSheet.user(@time_sheet.user).month(next_date[:month]).year(next_date[:year]).first
    prev_date = @time_sheet.previous_date
    @previous_month = TimeSheet.user(@time_sheet.user).month(prev_date[:month]).year(prev_date[:year]).first
    @recent_events = Event.recent_events_for(@time_sheet)
  end

  def new
    @time_sheet = TimeSheet.new
    @time_sheet.contract = Contract.find(params['contract_id'])
    @time_sheet.year = Date.today.year
    @time_sheet.month = Date.today.month
    @time_sheet.generate_work_days

    if params[:month]
      @time_sheet.month = params[:month]
    end
  end

  def create
    @time_sheet = TimeSheet.new(time_sheet_params)
    #@time_sheet.contract = Contract.find(params['contract_id'])
    authorize! :create, @time_sheet
    if @time_sheet.save
      redirect_to edit_time_sheet_path(@time_sheet)
      flash[:success] = I18n.t('time_sheet.save')
    else
      render :new
    end
  end

  def create_for_month_year
    contract = Contract.find(params[:contract_id])
    @time_sheet = TimeSheet.new(
      month: params[:month],
      year: params[:year],
      contract: contract
    )
    # :status is an optional URL parameter
    @time_sheet.status = params[:status] if params[:status]
    authorize! :create, @time_sheet
    if @time_sheet.save
      redirect_to edit_time_sheet_path(@time_sheet)
      flash[:success] = I18n.t('time_sheet.save')
    else
      redirect_to new_contract_time_sheet_path(contract)
    end
  end

  def edit
    set_time_sheet
    @time_sheet.generate_missing_work_days
    set_projects
  end

  def hand_in
    signed = params[:time_sheet] ? time_sheet_params[:signed] == '1' : false
    if signed && current_user.signature.nil?
      flash[:error] = t('signatures.signature_not_found_time_sheet')
      redirect_to :back and return
    elsif signed && !current_user.signature.nil?
      @time_sheet.update_attributes(user_signature: current_user.signature, signed: true, user_signed_at: Date.today)
    end
    @time_sheet.hand_in()
    flash[:success] = t('.flash')
    redirect_to time_sheet_path(@time_sheet)
  end

  def withdraw
    if @time_sheet.update(status: 'created', handed_in: false)
      flash[:success] = t('.flash')
    end
    redirect_to time_sheet_path(@time_sheet)
  end

  def update
    if @time_sheet.update(time_sheet_params)
      flash[:success] = t('helpers.flash.updated', model: @time_sheet.model_name.human.capitalize)
      redirect_to time_sheet_path(@time_sheet)
    else
      @time_sheet.generate_missing_work_days
      set_projects
      render :edit
    end
  end

  def accept_reject
    case params[:time_sheet_action]
      when 'reject'
        @time_sheet.update(time_sheet_params)
        @time_sheet.reject_as(current_user)
        flash[:success] = t('.flash.rejected')
        redirect_to time_sheet_path(@time_sheet)
      when 'accept'
        @time_sheet.accept_as(current_user)
        @time_sheet.update(wimi_signed: time_sheet_params[:wimi_signed])
        flash[:success] = t('.flash.accepted')
        redirect_to time_sheet_path(@time_sheet)
      else
        raise CanCan::AccessDenied
    end
  end

  def send_to_admin
    set_time_sheet
    @time_sheet.contract.chair.admin_users.each do |user|
      Event.add(:time_sheet_admin_mail, current_user, @time_sheet, user)
    end
    redirect_to time_sheet_path(@time_sheet)
  end

  def download
    set_time_sheet
    authorize! :show, @time_sheet
    @time_sheet.generate_missing_work_days
    redirect_to generate_pdf_path(doc_type: 'Timesheet', doc_id: @time_sheet, include_comments: params[:include_comments])
  end

  def destroy
    set_time_sheet
    @time_sheet.destroy
    #struggling with i18n, im sure this could be improved somehow
    flash[:success] = t('helpers.flash.destroyed', model: t('activerecord.models.time_sheet.one'))
    redirect_to dashboard_path
  end

  def close
    if @time_sheet.update(status: 'closed', handed_in: false)
      flash[:success] = t('.flash')
      Event.add(:time_sheet_closed, current_user, @time_sheet, @time_sheet.user)
    end
    redirect_to time_sheet_path(@time_sheet)
  end
  
  def reopen
    if @time_sheet.update(status: 'created', handed_in: false)
      flash[:success] = t('.flash')
    end
    redirect_to time_sheet_path(@time_sheet)
  end
  
  # Route that redirects to the current_user's first time sheet of this month
  # Creates that timesheet if it's not there yet and a contract for today's date exists
  def current
    today = Date.today
    current_time_sheet = TimeSheet.current(current_user)
    if current_time_sheet.any?
      if can? :edit, current_time_sheet.first
        redirect_to edit_time_sheet_path(current_time_sheet.first)
      else
        redirect_to time_sheet_path(current_time_sheet.first)
      end
    else
      contracts = current_user.contracts.at_date(today)
      if contracts.any?
        time_sheet = TimeSheet.new(contract: contracts.first, year: today.year, month: today.month)
        if time_sheet.save
          redirect_to edit_time_sheet_path(time_sheet)
        else
          render :new
        end
      else
        flash[:error] = I18n.t('time_sheet.no_contract')
        redirect_to dashboard_path
      end
    end
  end

  private

  def set_time_sheet
    @time_sheet = TimeSheet.find(params[:id])
  end

  def set_projects
    if @time_sheet && @time_sheet.user
      @projects = @time_sheet.user.projects
    else
      @projects = current_user.projects
    end
  end

  def time_sheet_params
    delocalize_config = {:start_time => :time, :end_time => :time}

    p = params[:time_sheet].permit(TimeSheet.column_names.map(&:to_sym), work_days_attributes: WorkDay.column_names.map(&:to_sym)).delocalize(delocalize_config)

    # this actually works, but man is it ugly
    # we should not be using delocalize
    if p[:work_days_attributes]
      p[:work_days_attributes].each do |index,d|
        if /[0-9]{4}/.match(d[:start_time])
          d[:start_time] = d[:start_time].slice(0..1) + ":" + d[:start_time].slice(2..-1)
        end
        if /[0-9]{4}/.match(d[:end_time])
          d[:end_time] = d[:end_time].slice(0..1) + ":" + d[:end_time].slice(2..-1)
        end
      end
    end

    p
  end
end
