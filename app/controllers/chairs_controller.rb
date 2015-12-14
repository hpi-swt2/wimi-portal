class ChairsController < ApplicationController
  before_action :set_chair, only: [:show, :accept_request, :remove_from_chair, :destroy, :update,  :set_admin, :withdraw_admin]

  before_action :authorize_admin, only: [:accept_request, :remove_from_chair, :set_admin, :withdraw_admin]
  before_action :authorize_superadmin, only: [:destroy, :new, :create, :edit, :update]
  before_action :authorize_admin_or_representative, only: [:show]

  def index
    @chairs = Chair.all
  end

  # Superadmin tasks:
  def destroy
    if @chair.destroy
      flash[:success] = I18n.t('chair.destroy.success', default: 'Chair was successfully destroyed.')
      redirect_to chairs_path
    else
      flash[:error] = I18n.t('chair.destroy.error', default: 'Chair could not be destroyed.')
      redirect_to chairs_path
    end
  end

  def new
    @chair = Chair.new
  end

  def create
    @chair = Chair.new(chair_params)
    
    if @chair.add_users(params[:admin_user], params[:representative_user])
      flash[:success] = I18n.t('chair.create.success', default: 'Chair successfully created.')
      redirect_to chairs_path
    else
      flash[:error] = I18n.t('chair.create.error', default: 'The form is not filled completely!')
      render :new
    end
  end

  def edit
    @chair = Chair.find(params[:id])
  end

  def update
    if @chair.edit_users(params[:admin_user], params[:representative_user])
      @chair.update(chair_params)
      flash[:success] = I18n.t('chair.update.success', default: 'Chair successfully updated.')
      redirect_to chairs_path
    else
      flash[:error] = I18n.t('chair.update.error', default: 'The form is not filled completely!')
      render :new
    end
  end

  # Admin / Representative tasks:
  def show
    @requests = @chair.chair_wimis.where(application: 'pending')
  end

  # Admin tasks:
  def accept_request
    chair_wimi = ChairWimi.find(params[:request])
    chair_wimi.application = 'accepted'

    if chair_wimi.save
      flash[:success] = I18n.t('chair.accept_request.success', default: 'Application was successfully accepted.')
      redirect_to chair_path(@chair)
    else
      flash[:error] = I18n.t('chair.accept_request.error', default: 'Accepting application failed')
      redirect_to chair_path(@chair)
    end
  end

  def remove_from_chair
    chair_wimi = ChairWimi.find(params[:request])

    if chair_wimi.remove(current_user)
      flash[:success] = I18n.t('chair.remove_from_chair.success', default: 'User was successfully removed.')
      redirect_to chair_path(@chair)
    else
      flash[:error] = I18n.t('chair.remove_from_chair.error', default: 'Destroying Chair_wimi failed')
      redirect_to chair_path(@chair)
    end
  end

  def set_admin
    chair_wimi = ChairWimi.find(params[:request])
    chair_wimi.admin = true
    
    if chair_wimi.save
      redirect_to chair_path(@chair), notice: 'Admin was successfully set.'
    else
      redirect_to chair_path(@chair), notice: 'Admin setting failed.'
    end
  end

  def withdraw_admin
    chair_wimi = ChairWimi.find(params[:request])
    if chair_wimi.withdraw_admin(current_user)
      redirect_to chair_path(@chair), notice: 'Admin rights was successfully removed.'
    else
      redirect_to chair_path(@chair), notice: 'Admin right removing failed.'
    end
  end

  # User task:
  def apply
    wimi = ChairWimi.new(chair_id: params[:chair], user: current_user, application: 'pending')

    success = false
    unless ChairWimi.find_by(user: current_user)
      success = wimi.save
    end

    if success
      flash[:success] = I18n.t('chair.apply.success', default: 'Chair wimi application was successfully created.')
      redirect_to chairs_path
    else
      flash[:error] = I18n.t('chair.apply.error', default: 'Saving chair wimi application failed')
      redirect_to chairs_path
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_chair
    @chair = Chair.find(params[:id])
  end

  def chair_params
    params.require(:chair).permit(:name)
  end

  protected
  def authorize_superadmin
    not_authorized unless current_user.superadmin
  end

  def authorize_admin
    not_authorized unless current_user.is_admin?(@chair)
  end

  def authorize_admin_or_representative
    not_authorized unless current_user.is_admin?(@chair) || current_user.is_representative?(@chair)
  end

  def not_authorized
    flash[:error] = I18n.t('chair.not_authorized', default: 'Not authorized for this chair.')
    redirect_to chairs_path
  end
end