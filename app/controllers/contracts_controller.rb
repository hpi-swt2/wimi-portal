class ContractsController < ApplicationController
  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = t('not_authorized')
    redirect_to dashboard_path
  end

  def new
    @contract = Contract.new
  end

  def create
    @contract = Contract.new(contract_params)
    if @contract.save
      redirect_to contract_path(@contract)
      flash[:success] = I18n.t('contract.save')
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
      flash[:success] = I18n.t('contract.update')
    else
      render :edit
    end
  end

  def destroy
    @contract.destroy
    redirect_to dashboard_path
    flash[:success] = I18n.t('contract.destroyed')
  end

  private

  def contract_params
    params.require(:contract).permit(Contract.column_names.map(&:to_sym))
  end
end
