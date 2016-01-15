class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy, :download]

  def index
    @trips = Trip.all
  end

  def show
    unless (@trip.user_id == current_user.id) || ((can? :show_trips, @trip.user) && (can? :edit_trip, @trip))
      redirect_to root_path
      flash[:error] = I18n.t('trip.not_authorized')
    end
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
      redirect_to @trip, notice: 'Trip was successfully created.'
    else
      fill_blank_items
      render :new
    end
  end

  def update
    if @trip.update(trip_params)
      redirect_to @trip, notice: 'Trip was successfully updated.'
    else
      fill_blank_items
      render :edit
    end
  end

  def destroy
    @trip.destroy
    redirect_to trips_url, notice: 'Trip was successfully destroyed.'
  end

  def download
  end

  def file
    trip = Trip.find(params[:id])
    trip.update_attribute(:status, 'applied')
    trip.update_attribute(:last_modified, Date.today)
    redirect_to Trip.find(params[:id])
  end

  def reject
    trip = Trip.find(params[:id])
    trip.update_attribute(:status, 'declined')
    trip.update_attribute(:last_modified, Date.today)
    redirect_to Trip.find(params[:id])
  end

  def accept
    trip = Trip.find(params[:id])
    trip.update_attribute(:status, 'accepted')
    trip.update_attribute(:last_modified, Date.today)
    redirect_to Trip.find(params[:id])
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
