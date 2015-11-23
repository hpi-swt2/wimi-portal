class WorkMonthsController < ApplicationController
  before_action :set_work_month, only: [:show, :edit, :update, :destroy]

  # GET /work_months
  # GET /work_months.json
  def index
    @work_months = WorkMonth.all
  end

  # GET /work_months/1
  # GET /work_months/1.json
  def show
    if invalid_user?
      redirect_to root_path
    end
  end

  # GET /work_months/new
  def new
    @work_month = WorkMonth.new
  end

  # GET /work_months/1/edit
  def edit
  end

  # POST /work_months
  # POST /work_months.json
  def create
    @work_month = WorkMonth.new(work_month_params)

    respond_to do |format|
      if @work_month.save
        format.html { redirect_to @work_month, notice: 'Work month was successfully created.' }
        format.json { render :show, status: :created, location: @work_month }
      else
        format.html { render :new }
        format.json { render json: @work_month.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /work_months/1
  # PATCH/PUT /work_months/1.json
  def update
    respond_to do |format|
      if @work_month.update(work_month_params)
        format.html { redirect_to @work_month, notice: 'Work month was successfully updated.' }
        format.json { render :show, status: :ok, location: @work_month }
      else
        format.html { render :edit }
        format.json { render json: @work_month.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_months/1
  # DELETE /work_months/1.json
  def destroy
    @work_month.destroy
    respond_to do |format|
      format.html { redirect_to work_months_url, notice: 'Work month was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_month
      @work_month = WorkMonth.find(params[:id])
    end

    def invalid_user?
      p @work_month.user_id != current_user.id
      @work_month.user_id != current_user.id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def work_month_params
      params.require(:work_month).permit(:name, :year)
    end
end
