class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy]

  def index
    @trips = Trip.all
  end

  def show
  end

  def new
    @trip = Trip.new
  end

  def edit
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      flash[:success] = 'Trip was successfully created.'
      redirect_to @trip
    else
      render :new
    end
  end

  def update
    if @trip.update(trip_params)
      flash[:success] = 'Trip was successfully updated.'
      redirect_to @trip
    else
      render :edit
    end
  end

  def destroy
    @trip.destroy
    flash[:success] = 'Trip was successfully destroyed.'
    redirect_to trips_url
  end

  private
    def set_trip
      @trip = Trip.find(params[:id])
    end

    def trip_params
      params[:trip].permit(Trip.column_names.map(&:to_sym))
    end
end
