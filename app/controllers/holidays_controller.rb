class HolidaysController < ApplicationController
  before_action :set_holiday, only: [:show, :edit, :update, :destroy]

  def index
    @holidays = Holiday.all
  end

  def show
  end

  def new
    @holiday = Holiday.new
  end

  def edit
  end

  def create
    @holiday = Holiday.new(holiday_params)
    if @holiday.save
      flash[:success] = 'Holiday was successfully created.'
      redirect_to @holiday
    else
      render :new
    end
  end

  def update
    if @holiday.update(holiday_params)
      flash[:success] = 'Holiday was successfully updated.'
      redirect_to @holiday
    else
      render :edit
    end
  end

  def destroy
    @holiday.destroy
    flash[:success] = 'Holiday was successfully destroyed.'
    redirect_to holidays_url
  end

  private
    def set_holiday
      @holiday = Holiday.find(params[:id])
    end

    def holiday_params
      params[:holiday].permit(Holiday.column_names.map(&:to_sym))
    end
end
