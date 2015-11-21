class HolidaysController < ApplicationController
  before_action :set_holiday, only: [:show, :edit, :update, :destroy]

  # GET /holidays
  # GET /holidays.json
  def index
    @holidays = Holiday.all
  end

  # GET /holidays/1
  # GET /holidays/1.json
  def show
  end

  # GET /holidays/new
  def new
    @holiday = Holiday.new
  end

  # GET /holidays/1/edit
  def edit
  end

  # POST /holidays
  # POST /holidays.json
  def create
    @holiday = Holiday.new(holiday_params.merge(user_id: current_user.id))
    #current_user.remaining_leave_this_year = current_user.remaining_leave_this_year - @holiday.duration

    respond_to do |format|
      if @holiday.save
        current_user.update_attribute(:remaining_leave_this_year, current_user.remaining_leave_this_year - @holiday.duration_this_year)
        current_user.update_attribute(:remaining_leave_next_year, current_user.remaining_leave_next_year - @holiday.duration_next_year)
        #if((current_user.remaining_leave_this_year - @holiday.duration_next_year) < 0)
        #    negativ = current_user.remaining_leave_this_year - @holiday.duration_next_year
        #    current_user.update_attribute(:remaining_leave_next_year, current_user.remaining_leave_next_year + negativ)
        #    current_user.update_attribute(:remaining_leave_this_year, current_user.remaining_leave_this_year - (@holiday.duration_this_year + negativ)
        #else
        #    current_user.update_attribute(:remaining_leave_this_year, current_user.remaining_leave_this_year - @holiday.duration_next_year)
        #end
        format.html { redirect_to @holiday, notice: 'Holiday was successfully created.' }
        format.json { render :show, status: :created, location: @holiday }
      else
        format.html { render :new }
        format.json { render json: @holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /holidays/1
  # PATCH/PUT /holidays/1.json
  def update
    respond_to do |format|
      if @holiday.update(holiday_params)
        format.html { redirect_to @holiday, notice: 'Holiday was successfully updated.' }
        format.json { render :show, status: :ok, location: @holiday }
      else
        format.html { render :edit }
        format.json { render json: @holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /holidays/1
  # DELETE /holidays/1.json
  def destroy
    if @holiday.end > Date.today
      current_user.update_attribute(:remaining_leave_this_year, current_user.remaining_leave_this_year + @holiday.duration_this_year)
      current_user.update_attribute(:remaining_leave_next_year, current_user.remaining_leave_next_year + @holiday.duration_next_year)
      
    end
    @holiday.destroy
    respond_to do |format|
      format.html { redirect_to holidays_url, notice: 'Holiday was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_holiday
      @holiday = Holiday.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def holiday_params
      params[:holiday].permit(Holiday.column_names.map(&:to_sym))
    end
end
