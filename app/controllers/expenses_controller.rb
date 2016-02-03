class ExpensesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource only: :index

  before_action :set_expense, only: [:show, :edit, :update, :destroy, :hand_in, :update_item_count]
  before_action :set_trip, only: [:new, :create, :update_item_count]

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = t('not_authorized')
    redirect_to trips_path
  end

  def new
    @trip = Trip.find(params[:trip_id])
    @expense = Expense.new(trip: @trip)
    @expense.user = current_user
    create_items
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.trip = @trip
    @expense.user = current_user
    fill_items

    if expense_params[:signature] == '1' && current_user.signature.nil?
      @expense.signature = false
      flash[:error] = t('signatures.signature_not_found')
    elsif expense_params[:signature] == '1' && !current_user.signature.nil?
      @expense.user_signature = current_user.signature
      @expense.user_signed_at = Date.today
    end

    if @expense.save
      redirect_to trip_path(@expense.trip)
      flash[:success] = I18n.t('expense.save')
    else
      render :new
    end
  end

  def edit
    if @expense.status == 'applied'
      redirect_to trip_path(@expense.trip)
      flash[:error] = I18n.t('expense.applied')
    end
  end

  def update

    new_expense_params = expense_params

    if new_expense_params[:signature] == '1' && current_user.signature.nil?
      new_expense_params[:signature] = false
      @expense.user_signature = nil
      @expense.user_signed_at = nil
      flash[:error] = t('signatures.signature_not_found')
    elsif new_expense_params[:signature] == '1' && !current_user.signature.nil?
      @expense.user_signature = current_user.signature
      @expense.user_signed_at = Date.today
    else
      @expense.user_signature = nil
      @expense.user_signed_at = nil
    end

    if @expense.update(new_expense_params)
      redirect_to trip_path(@expense.trip)
      flash[:success] = I18n.t('expense.update')
    else
      render :edit
    end
  end

  def destroy
    trip = @expense.trip
    if @expense.status == 'applied'
      redirect_to trip_path(@expense.trip)
      flash[:error] = I18n.t('expense.applied')
    else
      @expense.destroy
      redirect_to trip_url(trip)
      flash[:success] = I18n.t('expense.destroyed')
    end
  end

  def hand_in
    if @expense.status == 'saved'
      if @expense.update(status: 'applied')
        ActiveSupport::Notifications.instrument('event', {trigger: current_user.id, target: @expense.id, chair: current_user.chair, type: 'EventRequest', seclevel: :representative, status: 'expense'})
      end
    end
    redirect_to trip_path(@expense.trip)
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(Expense.column_names.map(&:to_sym), expense_items_attributes: [:id, :date, :breakfast, :lunch, :dinner, :annotation])
  end

  def set_trip
    @trip = Trip.find_by_id([params[:trip_id]])
  end

  def create_items
    for i in 0..(@trip.total_days - 1)
      day = @expense.expense_items.build
      day.date = @trip.date_start + i
    end
  end

  def fill_items
    i = 0
    @expense.expense_items.each do |item|
      item.date = @expense.trip.date_start + i
      i += 1
    end
  end
end
