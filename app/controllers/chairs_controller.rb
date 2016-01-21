class ChairsController < ApplicationController
  load_and_authorize_resource
  before_action :set_chair, only: [:show, :accept_request, :remove_from_chair, :destroy, :update, :set_admin, :withdraw_admin, :requests]

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = I18n.t('chairs.navigation.not_authorized')
    if current_user.is_admin? || current_user.is_representative?
      redirect_to chair_path(current_user.chair)
    else
      redirect_to dashboard_path
    end
  end

  def index
    @chairs = Chair.all
  end

  # Superadmin tasks:
  def destroy
    if @chair.destroy
      flash[:success] = I18n.t('chair.destroy.success')
    else
      flash[:error] = I18n.t('chair.destroy.error')
    end
    redirect_to chairs_path
  end

  def new
    @chair = Chair.new
  end

  def create
    @chair = Chair.new(chair_params)

    if @chair.add_users(params[:admin_user], params[:representative_user])
      flash[:success] = I18n.t('chair.create.success')
      redirect_to chairs_path
    else
      flash[:error] = I18n.t('chair.create.error')
      render :new
    end
  end

  def edit
    @chair = Chair.find(params[:id])
  end

  def update
    if @chair.edit_users(params[:admin_user], params[:representative_user])
      @chair.update(chair_params)
      flash[:success] = I18n.t('chair.update.success')
      redirect_to chairs_path
    else
      flash[:error] = I18n.t('chair.update.error')
      render :new
    end
  end

  def live_search
    @tasks = User.search(params[:q])

    #@tasks = Task.find_latest params[:q]

    render :layout => false
  end

  # Admin / Representative tasks:
  def show
    @requests = @chair.chair_wimis.where(application: 'pending')
  end

  # Show requests (Representative tasks):
  def requests
    @types = %w[holidays expenses trips]
    @statuses = %w[applied accepted declined]

    @allrequests = @chair.create_allrequests(@types, @statuses)
  end

  def requests_filtered
    @types = %w[holidays expenses trips]
    @statuses = %w[applied accepted declined]

    @types.delete_if { |type| !params.has_key?(type) }
    @statuses.delete_if { |status| !params.has_key?(status) }

    @allrequests = @chair.create_allrequests(@types, @statuses)
    render 'requests'
  end

  # Admin tasks:
  def accept_request
    chair_wimi = ChairWimi.find(params[:request])
    chair_wimi.application = 'accepted'

    if chair_wimi.save
      ActiveSupport::Notifications.instrument('event', {trigger: current_user.id, target: chair_wimi.user.id, chair: @chair, type: 'EventUserChair', seclevel: :admin, status: 'added'})
      flash[:success] = I18n.t('chair.accept_request.success')
    else
      flash[:error] = I18n.t('chair.accept_request.error')
    end
    redirect_to chair_path(@chair)
  end

  def remove_from_chair
    chair_wimi = ChairWimi.find(params[:request])
    status = ('removed' if chair_wimi.application == 'accepted') || ('declined' if chair_wimi.application == 'pending')

    if chair_wimi.remove(current_user)
      ActiveSupport::Notifications.instrument('event', {trigger: current_user.id, target: chair_wimi.user.id, chair: @chair, type: 'EventUserChair', seclevel: :admin, status: status})
      flash[:success] = I18n.t('chair.remove_from_chair.success')
    else
      flash[:error] = I18n.t('chair.remove_from_chair.error')
    end
    redirect_to chair_path(@chair)
  end

  def set_admin
    chair_wimi = ChairWimi.find(params[:request])
    chair_wimi.admin = true

    if chair_wimi.save
      ActiveSupport::Notifications.instrument('event', {trigger: current_user.id, target: chair_wimi.user.id, chair: @chair, type: 'EventAdminRight', seclevel: :admin, status: 'added'})
      flash[:success] = I18n.t('chair.set_admin.success')
    else
      flash[:error] = I18n.t('chair.set_admin.error')
    end
    redirect_to chair_path(@chair)
  end

  def withdraw_admin
    chair_wimi = ChairWimi.find(params[:request])
    if chair_wimi.withdraw_admin(current_user)
      ActiveSupport::Notifications.instrument('event', {trigger: current_user.id, target: chair_wimi.user.id, chair: @chair, type: 'EventAdminRight', seclevel: :admin, status: 'removed'})
      flash[:success] = I18n.t('chair.withdraw.success')
    else
      flash[:error] = I18n.t('chair.withdraw.error')
    end
    redirect_to chair_path(@chair)
  end

  # User task:
  def apply
    wimi = ChairWimi.new(chair_id: params[:chair], user: current_user, application: 'pending')

    success = false
    unless ChairWimi.find_by(user: current_user)
      ActiveSupport::Notifications.instrument('event', {trigger: current_user.id, chair: wimi.chair, type: 'EventChairApplication', seclevel: :admin})
      success = wimi.save
    end

    if success
      flash[:success] = I18n.t('chair.apply.success')
    else
      flash[:error] = I18n.t('chair.apply.error')
    end
    redirect_to chairs_path
  end

  private

  def set_chair
    @chair = Chair.find(params[:id])
  end

  def chair_params
    params.require(:chair).permit(:name)
  end
end
