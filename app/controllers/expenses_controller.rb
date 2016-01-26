class ExpensesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource only: :index

  before_action :set_expense, only: [:show, :edit, :update, :destroy, :hand_in]
  before_action :set_trip, only: [:new, :create]

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = I18n.t('not_authorized')
    redirect_to trips_path
  end

  def index
    @expenses = Expense.where(user: current_user)
  end

  def show
  end

  def new
    @trip = Trip.find(params[:trip_id])
    @expense = Expense.new(trip: @trip)
    @expense.user = current_user
    8.times { @expense.expense_items.build }
  end

  def edit
    if @expense.status == 'applied'
      redirect_to trip_path(@expense.trip)
      flash[:error] = I18n.t('expense.applied')
    else
      fill_blank_items
    end
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.trip = @trip
    @expense.user = current_user

    if @expense.save
      redirect_to trip_path(@expense.trip), notice: 'expense was successfully created.'
    else
      fill_blank_items
      render :new
    end
  end

  def update
    if @expense.update(expense_params)
      redirect_to trip_path(@expense.trip), notice: 'expense was successfully updated.'
    else
      fill_blank_items
      render :edit
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

  def destroy
    trip = @expense.trip
    if @expense.status == 'applied'
      redirect_to trip_path(@expense.trip)
      flash[:error] = I18n.t('expense.applied')
    else
      @expense.destroy
      redirect_to trip_url(trip), notice: 'expense was successfully destroyed.'
    end
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(Expense.column_names.map(&:to_sym), expense_items_attributes: [:id, :date, :breakfast, :lunch, :dinner, :annotation])
  end

  def fill_blank_items
    (8 - @expense.expense_items.size).times { @expense.expense_items.build }
  end

  def set_trip
    @trip = Trip.find_by_id([params[:trip_id]])
  end
end
