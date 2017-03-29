class TripsController < ApplicationController
  load_and_authorize_resource

  before_action :set_trip, only: [:show, :edit, :update, :destroy, :download, :apply, :hand_in]
  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = t('not_authorized')
    if current_user && !current_user.is_superadmin?
      redirect_to trips_path
    else
      redirect_to dashboard_path
    end
  end

  def index
    @trips = Trip.where(user: current_user)
    redirect_to user_path(current_user, anchor: 'trips')
  end

  def show
    unless (@trip.user == current_user) || ((can? :see_trips, @trip.user) && (can? :edit_trip, @trip))
      redirect_to root_path
      flash[:error] = I18n.t('not_authorized')
    end
  end

  def new
    @trip = Trip.new
  end

  def edit
    if @trip.status == 'applied'
      redirect_to @trip
      flash[:error] = I18n.t('trip.applied')
    end
  end

  def create
    parse_date
    @trip = Trip.new(trip_params)
    @trip.user = current_user

    if trip_params[:signature] == '1' && current_user.signature.nil?
      @trip.signature = false
      flash[:error] = t('signatures.signature_not_found')
    elsif trip_params[:signature] == '1' && !current_user.signature.nil?
      @trip.user_signature = current_user.signature
      @trip.user_signed_at = Date.today
    end

    if @trip.save
      redirect_to @trip
      flash[:success] = I18n.t('trip.save')
    else
      render :new
    end
  end

  def update
    parse_date
    @trip.update(status: 'saved')

    new_trip_params = trip_params

    if new_trip_params[:signature] == '1' && current_user.signature.nil?
      new_trip_params[:signature] = false
      @trip.user_signature = nil
      @trip.user_signed_at = nil
      flash[:error] = t('signatures.signature_not_found')
    elsif new_trip_params[:signature] == '1' && !current_user.signature.nil?
      @trip.user_signature = current_user.signature
      @trip.user_signed_at = Date.today
    else
      @trip.user_signature = nil
      @trip.user_signed_at = nil
    end

    if @trip.update(new_trip_params)
      redirect_to @trip
      flash[:success] = I18n.t('trip.update')
    else
      render :edit
    end
  end

  def hand_in
    if @trip.status == 'saved'
      @trip.update(status: 'applied')
    end
    redirect_to trips_path
  end

  def destroy
    if @trip.status == 'applied'
      redirect_to @trip
      flash[:error] = I18n.t('trip.applied')
    else
      @trip.destroy
      redirect_to trips_url
      flash[:sucess] = I18n.t('trip.destroyed')
    end
  end

  def download
  end

  def reject
    if (can? :read, @trip) && @trip.status == 'applied'
      @trip.update_attributes(status: 'declined', last_modified: Date.today, person_in_power: current_user, rejection_message: get_rejection_message)
      redirect_to @trip.user
    else
      redirect_to root_path
      flash[:error] = t('not_authorized')
    end
  end

  def accept
    if (can? :read, @trip) && @trip.status == 'applied'
      @trip.update_attributes(status: 'accepted', last_modified: Date.today, person_in_power: current_user, representative_signature: current_user.signature, representative_signed_at: Date.today)
      redirect_to @trip.user
    else
      redirect_to root_path
      flash[:error] = t('not_authorized')
    end
  end

  def accept_reject
    params[:commit] == t('trips.show.reject') ? reject : accept
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(Trip.column_names.map(&:to_sym))
  end

  def get_rejection_message
    params['trip'].nil? ? '' : trip_params['rejection_message']
  end

  def parse_date
    params['trip']['date_start'] = Date.strptime(params['trip']['date_start'], t('date.formats.default'))
    params['trip']['date_end'] = Date.strptime(params['trip']['date_end'], t('date.formats.default'))
  end
end
