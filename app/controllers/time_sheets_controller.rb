class TimeSheetsController < ApplicationController
#  before_action :set_time_sheet, only: [:show, :edit, :update, :destroy, :accept_reject, :hand_in]

  layout "action_sidebar"

  load_and_authorize_resource
  skip_authorize_resource only: :download
  
  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = t('not_authorized')
    redirect_to dashboard_path
  end

  def index
    @contracts = Contract.accessible_by(current_ability, :index).order(end_date: :desc)
  end

  def show
    set_time_sheet
    set_projects
    next_date = @time_sheet.next_date
    @next_month = TimeSheet.user(@time_sheet.user).month(next_date[:month]).year(next_date[:year]).first
    prev_date = @time_sheet.previous_date
    @previous_month = TimeSheet.user(@time_sheet.user).month(prev_date[:month]).year(prev_date[:year]).first
  end

  def new
    @time_sheet = TimeSheet.new
    @time_sheet.contract = Contract.find(params['contract_id'])
    @time_sheet.year = Date.today.year
    @time_sheet.month = Date.today.month
    @time_sheet.generate_work_days
    set_projects

    if params[:month]
      @time_sheet.month = params[:month]
    end
  end

  def create
    @time_sheet = TimeSheet.new(time_sheet_params)
    @time_sheet.contract = Contract.find(params['contract_id'])

    if @time_sheet.save
      redirect_to edit_time_sheet_path(@time_sheet)
      flash[:success] = I18n.t('time_sheet.save')
    else
      @time_sheet.generate_missing_work_days
      set_projects
      render :new
    end
  end

  def edit
    set_time_sheet
    @time_sheet.generate_missing_work_days
    set_projects
  end

  def hand_in
    if time_sheet_params[:signed] == '1' && current_user.signature.nil?
      @time_sheet.signed = false
      redirect_to :back
      flash[:error] = t('signatures.signature_not_found_time_sheet')
    else
      if time_sheet_params[:signed] == '1' && !current_user.signature.nil?
        @time_sheet.update_attributes(user_signature: current_user.signature, signed: true, user_signed_at: Date.today)
      end
      @time_sheet.update(status: 'pending', handed_in: true, hand_in_date: Date.today)
      ActiveSupport::Notifications.instrument('event', trigger: @time_sheet.id, target: @time_sheet.contract.user_id, seclevel: :wimi, type: 'EventTimeSheetSubmitted')
      redirect_to time_sheets_path
    end
  end

  def accept
#    time_sheet = TimeSheet.find(params[:id])
    @time_sheet.update(status: 'accepted', last_modified: Date.today, signer: current_user.id, representative_signature: current_user.signature, representative_signed_at: Date.today)
    ActiveSupport::Notifications.instrument('event', trigger: @time_sheet.id, target: @time_sheet.contract.user_id, seclevel: :hiwi, type: 'EventTimeSheetAccepted')
    redirect_to dashboard_path
  end

  def reject
#    time_sheet = TimeSheet.find(params[:id])
    @time_sheet.update(status: 'rejected', handed_in: false, last_modified: Date.today, signer: current_user.id)
    ActiveSupport::Notifications.instrument('event', trigger: @time_sheet.id, target: @time_sheet.contract.user_id, seclevel: :hiwi, type: 'EventTimeSheetDeclined')
    redirect_to dashboard_path
  end

  def update
    if @time_sheet.update(time_sheet_params)
      flash[:success] = 'Time Sheet was successfully updated.'
      redirect_to time_sheet_path(@time_sheet)
    else
      @time_sheet.generate_missing_work_days
      set_projects
      render :edit
    end
  end

  def accept_reject
    if params[:commit] == I18n.t('time_sheets.show_footer.reject')
      @time_sheet.update(time_sheet_params)
      reject
    else
      @time_sheet.update(wimi_signed: time_sheet_params[:wimi_signed])
      accept
    end
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
    redirect_to time_sheets_path
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

    params[:time_sheet].permit(TimeSheet.column_names.map(&:to_sym), work_days_attributes: WorkDay.column_names.map(&:to_sym)).delocalize(delocalize_config)
  end
end
