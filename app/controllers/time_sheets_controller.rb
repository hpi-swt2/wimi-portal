class TimeSheetsController < ApplicationController
#  before_action :set_time_sheet, only: [:show, :edit, :update, :destroy, :accept_reject, :hand_in]

  load_and_authorize_resource
  
  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = t('not_authorized')
    redirect_to dashboard_path
  end

  def index
    @contracts = Contract.accessible_by(current_ability, :index).order(end_date: :desc)
  end

  def show
    set_time_sheet
  end

  def new
    @time_sheet = TimeSheet.new
    @time_sheet.contract = Contract.find(params['contract_id'])
    @time_sheet.year = Date.today.year
    @time_sheet.month = Date.today.month
    @time_sheet.generate_work_days
  end

  def create
    @time_sheet = TimeSheet.new(time_sheet_params)
    @time_sheet.contract = Contract.find(params['contract_id'])

    if @time_sheet.save
      redirect_to edit_time_sheet_path(@time_sheet)
      flash[:success] = I18n.t('time_sheet.save')
    else
      render :new
    end
  end

  def edit
    set_time_sheet
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
      redirect_to user_path(current_user, anchor: 'timesheets')
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
      redirect_to time_sheets_path(month: @time_sheet.month, year: @time_sheet.year, contract: @time_sheet.contract)
    else
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

  private

  def set_time_sheet
    @time_sheet = TimeSheet.find(params[:id])
  end

  def time_sheet_params
    params[:time_sheet].permit(TimeSheet.column_names.map(&:to_sym), work_days_attributes: WorkDay.column_names.map(&:to_sym))
  end
end
