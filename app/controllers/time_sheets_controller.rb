class TimeSheetsController < ApplicationController
  before_action :set_time_sheet, only: [:show, :edit, :update, :destroy, :accept_reject]

  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = I18n.t('not_authorized')
    redirect_to dashboard_path
  end

  def show
  end

  def new
    @time_sheet = TimeSheet.new
  end

  def edit
  end

  def hand_in
    time_sheet = TimeSheet.find(params[:id])
    time_sheet.update(status: 'pending', handed_in: true, hand_in_date: Date.today)
    ActiveSupport::Notifications.instrument('event', trigger: time_sheet.id, target: time_sheet.project_id, seclevel: :wimi, type: 'EventTimeSheetSubmitted')
    redirect_to dashboard_path
  end

  def accept
    time_sheet = TimeSheet.find(params[:id])
    time_sheet.update(status: 'accepted', last_modified: Date.today, signer: current_user.id)
    ActiveSupport::Notifications.instrument('event', trigger: time_sheet.id, target: time_sheet.user_id, seclevel: :hiwi, type: 'EventTimeSheetAccepted')
    redirect_to dashboard_path
  end

  def reject
    time_sheet = TimeSheet.find(params[:id])
    time_sheet.update(status: 'rejected', handed_in: false, last_modified: Date.today, signer: current_user.id)
    ActiveSupport::Notifications.instrument('event', trigger: time_sheet.id, target: time_sheet.user_id, seclevel: :hiwi, type: 'EventTimeSheetDeclined')
    redirect_to dashboard_path
  end

  def update
    if @time_sheet.update(time_sheet_params)
      flash[:success] = 'Time Sheet was successfully updated.'
      redirect_to work_days_path(month: @time_sheet.month, year: @time_sheet.year, project: @time_sheet.project)
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
    params[:time_sheet].permit(TimeSheet.column_names.map(&:to_sym))
  end
end
