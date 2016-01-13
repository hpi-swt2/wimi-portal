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
    fill_blank_items
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user = current_user

    if @trip.save
      request_applied if @trip.status == 'applied'
      redirect_to @trip, notice: 'Trip was successfully created.'
    else
      fill_blank_items
      render :new
    end
  end

  def update
    if @trip.update(trip_params)
      request_applied if @trip.status == 'applied' && status == 'saved'
      redirect_to @trip, notice: 'Trip was successfully updated.'
    else
      fill_blank_items
      render :edit
    end
  end

  def request_applied
    if current_user.chair
      ActiveSupport::Notifications.instrument('event', {trigger: current_user.id, target: @trip.id, chair: current_user.chair, type: 'EventRequest', seclevel: :representative, status: 'trip'})
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

  def fill_blank_items
    (2 - @trip.trip_datespans.size).times {@trip.trip_datespans.build}
  end
end
