class TravelExpenseReportsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource only: :index

  before_action :set_travel_expense_report, only: [:show, :edit, :update, :destroy, :hand_in]
  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = I18n.t('chairs.navigation.not_authorized')
    redirect_to travel_expense_reports_path
  end

  def index
    @travel_expense_reports = TravelExpenseReport.where(user: current_user)
  end

  def show
    unless can? :read, @travel_expense_report
      redirect_to dashboard_path
    end
  end

  def new
    @travel_expense_report = TravelExpenseReport.new
    @travel_expense_report.user = current_user
    8.times {@travel_expense_report.travel_expense_report_items.build}
  end

  def edit
    fill_blank_items
  end

  def create
    @travel_expense_report = TravelExpenseReport.new(travel_expense_report_params)
    @travel_expense_report.user = current_user

    if @travel_expense_report.save
      redirect_to @travel_expense_report, notice: 'Travel expense report was successfully created.'
    else
      fill_blank_items
      render :new
    end
  end

  def update
    if @travel_expense_report.update(travel_expense_report_params)
      redirect_to @travel_expense_report, notice: 'Travel expense report was successfully updated.'
    else
      fill_blank_items
      render :edit
    end
  end

  def hand_in
    if @travel_expense_report.status == 'saved'
      if @travel_expense_report.update(status: 'applied')
        ActiveSupport::Notifications.instrument('event', {trigger: current_user.id, target: @travel_expense_report.id, chair: current_user.chair, type: 'EventRequest', seclevel: :representative, status: 'travel_expense_report'})
      end
    end
    redirect_to travel_expense_reports_path
  end

  def destroy
    @travel_expense_report.destroy
    redirect_to travel_expense_reports_url, notice: 'Travel expense report was successfully destroyed.'
  end

  private

  def set_travel_expense_report
    @travel_expense_report = TravelExpenseReport.find(params[:id])
  end

  def travel_expense_report_params
    params.require(:travel_expense_report).permit(TravelExpenseReport.column_names.map(&:to_sym), travel_expense_report_items_attributes: [:id, :date, :breakfast, :lunch, :dinner, :annotation])
  end

  def fill_blank_items
    (8 - @travel_expense_report.travel_expense_report_items.size).times {@travel_expense_report.travel_expense_report_items.build}
  end
end
