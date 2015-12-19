class ChairsController < ApplicationController
  load_and_authorize_resource
  before_action :set_chair, only: [:show, :accept_request, :remove_from_chair, :destroy, :update, :set_admin, :withdraw_admin, :requests]

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = 'You are not authorized to visit this page.'
    redirect_to chairs_path
  end


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

  def requests
    @allrequests = @chair.get_all_requests
  end

  def set_admin
    chair_wimi = ChairWimi.find(params[:request])
    chair_wimi.admin = true

    if chair_wimi.save
      flash[:success] = I18n.t('chair.set_admin.success', default: 'Admin was successfully set.')
      redirect_to chair_path(@chair)
    else
      flash[:error] = I18n.t('chair.set_admin.error', default: 'Admin setting failed.')
      redirect_to chair_path(@chair)
    end
  end

  def withdraw_admin
    chair_wimi = ChairWimi.find(params[:request])
    if chair_wimi.withdraw_admin(current_user)
      flash[:success] = I18n.t('chair.withdraw.success', default: 'Admin rights was successfully removed.')
      redirect_to chair_path(@chair)
    else
      flash[:error] = I18n.t('chair.withdraw.error', default: 'Admin right removing failed.')
      redirect_to chair_path(@chair)
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
  def set_chair
    @chair = Chair.find(params[:id])
  end

  def chair_params
    params.require(:chair).permit(:name)
  end
end