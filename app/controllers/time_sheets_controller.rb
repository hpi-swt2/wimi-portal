class TimeSheetsController < ApplicationController
  before_action :set_time_sheet, only: [:show, :edit, :update, :destroy]

  # GET /time_sheets/1
  # GET /time_sheets/1.json
  def show
  end

  # GET /time_sheets/new
  def new
    @time_sheet = TimeSheet.new
  end

  # GET /time_sheets/1/edit
  def edit
  end

  # PATCH/PUT /time_sheets/1
  # PATCH/PUT /time_sheets/1.json
  def update
    respond_to do |format|
      if @time_sheet.update(time_sheet_params)
        format.html { redirect_to work_days_path(month: @time_sheet.month, year: @time_sheet.year, project: @time_sheet.project)}
        format.json { render :show, status: :ok, location: @time_sheet }
      else
        format.html { render :edit }
        format.json { render json: @time_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_sheet
      @time_sheet = TimeSheet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_sheet_params
      params.require(:time_sheet).permit(:month, :year, :salary, :salary_is_per_month, :workload, :workload_is_per_month, :user_id, :project_id)
    end
end
