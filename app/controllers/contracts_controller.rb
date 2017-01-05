class ContractsController < ApplicationController
  load_and_authorize_resource

  skip_authorize_resource only: :dismiss

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = t('not_authorized')
    redirect_to contracts_path
  end

  def index
    # @contracts = Contract.accessible_by(current_ability, :index)
    @contracts = Contract.all.order(end_date: :desc).select {|c| can? :index, c}
    # If there is only one contract available to view to a user and
    # no permissions are available to create one (which is possible on the index page)
    # then redirect directly to the show page of the only contract.
    if @contracts.count == 1 and current_ability.cannot?(:new, Contract)
      redirect_to contract_path(@contracts.first)
    end
  end

  def new
    @contract = Contract.new
  end

  def create
    @contract = Contract.new(contract_params)
    if @contract.save
      redirect_to contract_path(@contract)
      flash[:success] = t('helpers.flash.created', model: @contract.model_name.human.titleize)
    else
      render :new
    end
  end

  def edit
    
  end

  def update
    new_contract_params = contract_params

    if @contract.update(new_contract_params)
      redirect_to contract_path(@contract)
      flash[:success] = t('helpers.flash.updated', model: @contract.model_name.human.titleize)
    else
      render :edit
    end
  end

  def destroy
    @contract.destroy
    redirect_to contracts_path
    flash[:success] = t('helpers.flash.destroyed', model: @contract.model_name.human.titleize)
  end

  def dismiss
    contract = Contract.find(params[:id])
    authorize! :show, contract
    month = params[:month]
    entry = DismissedMissingTimesheet.new(user: current_user, contract: contract, month: month)
    if entry.save
      flash[:success] = I18n.t('dashboard.index.dismissed')
    end
    redirect_to dashboard_path
  end

  private

  def contract_params
    params.require(:contract).permit(Contract.column_names.map(&:to_sym))
  end
end
