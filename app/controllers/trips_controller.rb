class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy, :download, :apply]

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
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user = current_user
    @trip.status = 'saved'

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
      else
        format.html { render :new }
      end
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
    respond_to do |format|
      format.html { redirect_to trips_url, notice: 'Trip was successfully destroyed.' }
    end
  end

  def apply
    @trip.status = 'applied'
    if @trip.save
      redirect_to @trip, notice: 'Application was successfully accepted.'
    else
      redirect_to @trip, notice: 'Accepting application failed'
    end
  end

  def withdraw
    @trip.status = 'saved'
    if @trip.save
      redirect_to @trip, notice: 'Withdrawal was successfully accepted.'
    else
      redirect_to @trip, notice: 'Withdrawal application failed'
    end
  end

  def download
  end

  private
    def set_trip
      @trip = Trip.find(params[:id])
    end

    def trip_params
	    params.require(:trip).permit(:name, :destination, :reason, :annotation, :signature, :status, trip_datespans_attributes:[:id,:start_date, :end_date,:days_abroad])
    end
end
