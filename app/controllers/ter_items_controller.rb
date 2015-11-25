class TerItemsController < ApplicationController
  before_action :set_trip
  before_action :set_ter

  def create
    @ter_item = @travel_expense_report.ter_items.build(ter_item_params)

    respond_to do |format|
      if @ter_item.save
        format.html { redirect_to edit_trip_travel_expense_report_url(@trip,@travel_expense_report), notice: 'Travel expense report was successfully created.' }
        format.json { render :edit, status: :created, location: @travel_expense_report }
      else
        format.html { render 'travel_expense_reports/edit'}
        format.json { render json: @ter_item.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_ter
      @travel_expense_report = @trip.travel_expense_reports.find(params[:travel_expense_report_id])
    end

    def set_trip
      @trip = Trip.find(params[:trip_id])
    end

    def ter_item_params
      params.require(:ter_item).permit(:amount,:purpose)
    end

end
