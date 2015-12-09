class TravelExpenseReportsController < ApplicationController
  before_action :set_travel_expense_report, only: [:show, :edit, :update, :destroy]

  def index
    @travel_expense_reports = TravelExpenseReport.all
  end

  def show
  end

  def new
    @travel_expense_report = TravelExpenseReport.new
    @travel_expense_report.user = current_user
    8.times {@travel_expense_report.travel_expense_report_items.build}
  end

  def edit
  end

  def create
    @travel_expense_report = TravelExpenseReport.new(travel_expense_report_params)
    @travel_expense_report.user = current_user

    respond_to do |format|
      if @travel_expense_report.save
        format.html { redirect_to @travel_expense_report, notice: 'Travel expense report was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @travel_expense_report.update(travel_expense_report_params)
        format.html { redirect_to @travel_expense_report, notice: 'Travel expense report was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @travel_expense_report.destroy
    respond_to do |format|
      format.html { redirect_to travel_expense_reports_url, notice: 'Travel expense report was successfully destroyed.' }
    end
  end

  private
    def set_travel_expense_report
      @travel_expense_report = TravelExpenseReport.find(params[:id])
    end

    def travel_expense_report_params
      params.require(:travel_expense_report).permit(:first_name, :last_name, :inland, :country, :location_from, :location_via, :location_to, :reason, :date_start, :date_end, :car, :public_transport, :vehicle_advance, :hotel, :general_advance, :user_id, travel_expense_report_items_attributes:[:date,:breakfast,:lunch,:dinner])
    end
end
