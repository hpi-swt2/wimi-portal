class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy, :download, :apply, :hand_in]

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
    if @trip.status == 'applied'
      redirect_to @trip, notice: 'Trip is already applied.'
    else
      fill_blank_items
    end
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user = current_user
    

    if @trip.save
      redirect_to @trip, notice: 'Trip was successfully created.'
    else
      fill_blank_items
      render :new
    end
  end

  def update
    @trip.update(status: 'saved')
    if @trip.update(trip_params)
      redirect_to @trip, notice: 'Trip was successfully updated.'
    else
      fill_blank_items
      render :edit
    end
  end

  def hand_in
    if @trip.status == 'saved'
      if @trip.update(status: 'applied')
        ActiveSupport::Notifications.instrument('event', {trigger: current_user.id, target: @trip.id, chair: current_user.chair, type: 'EventRequest', seclevel: :representative, status: 'trip'})
      end
    end
    redirect_to trips_path
  end

  def destroy
    if @trip.status == 'applied'
      redirect_to @trip, notice: 'Trip is already applied.'
    else
      @trip.destroy
      redirect_to trips_url, notice: 'Trip was successfully destroyed.'
    end
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

  def fill_blank_items
    (2 - @trip.trip_datespans.size).times {@trip.trip_datespans.build}
  end
end
