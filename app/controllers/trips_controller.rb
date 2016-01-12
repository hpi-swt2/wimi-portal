class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy, :download]

  def index
    @trips = Trip.all
  end

  def show
  end

  def new
    @trip = Trip.new
    2.times {@trip.trip_datespans.build}
  end

  def edit
    (2 - @trip.trip_datespans.size).times {@trip.trip_datespans.build}
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user = current_user

    if @trip.save
      redirect_to @trip, notice: 'Trip was successfully created.'
    else
      render :new
    end
  end

  def update
    if @trip.update(trip_params)
      redirect_to @trip, notice: 'Trip was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @trip.destroy
    redirect_to trips_url, notice: 'Trip was successfully destroyed.'
  end

  def download
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(Trip.column_names.map(&:to_sym), trip_datespans_attributes: [:id, :start_date, :end_date, :days_abroad])
  end
end
