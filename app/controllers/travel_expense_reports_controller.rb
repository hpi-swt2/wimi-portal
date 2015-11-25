class TravelExpenseReportsController < ApplicationController
  before_action :set_trip
  before_action :set_travel_expense_report, only: [:show, :edit, :update, :destroy]

  # GET /travel_expense_reports
  # GET /travel_expense_reports.json
  def index
    @travel_expense_reports = @trip.travel_expense_reports
  end

  # GET /travel_expense_reports/1
  # GET /travel_expense_reports/1.json
  def show
    @sum = 0
    @travel_expense_report.ter_items.each do |t|
      @sum += t.amount
    end
  end

  # GET /travel_expense_reports/new
  def new
    @travel_expense_report = @trip.travel_expense_reports.build
  end

  # GET /travel_expense_reports/1/edit
  def edit
  end

  # POST /travel_expense_reports
  # POST /travel_expense_reports.json
  def create
    @travel_expense_report = @trip.travel_expense_reports.build(travel_expense_report_params)
    @travel_expense_report.advance = 0

    respond_to do |format|
      if @travel_expense_report.save
        format.html { redirect_to trip_travel_expense_report_url(@trip,@travel_expense_report), notice: 'Travel expense report was successfully created.' }
        format.json { render :show, status: :created, location: @travel_expense_report }
      else
        format.html { render :new }
        format.json { render json: @travel_expense_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /travel_expense_reports/1
  # PATCH/PUT /travel_expense_reports/1.json
  def update
    respond_to do |format|
      if @travel_expense_report.update(travel_expense_report_params)
        format.html { redirect_to trip_travel_expense_report_url(@trip,@travel_expense_report), notice: 'Travel expense report was successfully updated.' }
        format.json { render :show, status: :ok, location: @travel_expense_report }
      else
        format.html { render :edit }
        format.json { render json: @travel_expense_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /travel_expense_reports/1
  # DELETE /travel_expense_reports/1.json
  def destroy
    @travel_expense_report.destroy
    respond_to do |format|
      format.html { redirect_to trip_travel_expense_reports_url(@trip), notice: 'Travel expense report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_travel_expense_report
      @travel_expense_report = @trip.travel_expense_reports.find(params[:id])
    end

    def set_trip
      @trip = Trip.find(params[:trip_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def travel_expense_report_params
      params.require(:travel_expense_report).permit(:name,:advance)
    end
end
