class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy ]

  def index
    @expenses = Expense.all
  end

  def show
  end

  def new
    @expense = Expense.new
  end

  def edit
  end

  def create
    @expense = Expense.new(expense_params)
    if @expense.save
      flash[:success] = 'Expense was successfully created.'
      redirect_to @expense
    else
      render :new
    end
  end

  def update
    if @expense.update(expense_params)
      flash[:success] = 'Expense was successfully updated.'
      redirect_to @expense
    else
      render :edit
    end
  end

  def destroy
    @expense.destroy
    flash[:success] = 'Expense was successfully destroyed.'
    redirect_to expenses_url
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params[:expense].permit(Expense.column_names.map(&:to_sym))
  end
end
