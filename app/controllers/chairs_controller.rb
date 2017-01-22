class ChairsController < ApplicationController
  
  load_and_authorize_resource
  #before_action :set_chair, only: [:show, :accept_request, :remove_user, :destroy, :update, :set_admin, :withdraw_admin, :requests]

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = t('chairs.navigation.not_authorized')
    if current_user.is_admin? || current_user.is_representative?
      redirect_to chair_path(current_user.chair)
    else
      redirect_to dashboard_path
    end
  end

  def index
    # If there is only one chair available to view to a user and
    # no permissions are available to create one (which is possible on the index page)
    # then redirect directly to the show page of the only chair.
    if @chairs.count == 1 and current_ability.cannot?(:new, Chair)
      redirect_to chair_path(@chairs.first)
    end
  end

  # Superadmin tasks:
  def destroy
    if @chair.destroy
      flash[:success] = t('helpers.flash.destroyed', model: @chair.model_name.human.capitalize)
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

    if @chair.set_initial_users(params[:admins], params[:representative]) && @chair.save
      flash[:success] = t('helpers.flash.created', model: @chair.model_name.human.capitalize)
      redirect_to chairs_path
    else
      render :new
    end
  end

  def edit
    @chair = Chair.find(params[:id])
  end

  def update
    if @chair.set_initial_users(params[:admins], params[:representative]) && @chair.update(chair_params)
      flash[:success] = t('helpers.flash.updated', model: @chair.model_name.human.capitalize)
      redirect_to chair_path(@chair)
    else
      render :new
    end
  end

  def admin_search
    @results = User.search(params[:q], Chair.find_by(id: params[:chair_search_id]))
    render layout: false
  end

  def representative_search
    @results = User.search(params[:q], Chair.find_by(id: params[:chair_search_id]))
    render layout: false
  end

  # Admin / Representative tasks:
  def show
    @requests = @chair.chair_wimis.where(application: 'pending')
    @user = current_user
  end

  # Show requests (Representative tasks):
  def requests
    @types = %w[holidays expenses trips]
    @statuses = %w[applied accepted declined]

    @allrequests = @chair.create_allrequests(@types, @statuses)
  end

  def requests_filtered # TODO: merge with #requests action
    @types = %w[holidays expenses trips]
    @statuses = %w[applied accepted declined]

    @types.delete_if { |type| !params.has_key?(type) }
    @statuses.delete_if { |status| !params.has_key?(status) }

    @allrequests = @chair.create_allrequests(@types, @statuses)
    render 'requests'
  end

#  # Admin tasks:
#  def accept_request # applying for chair is deprecated
#    chair_wimi = ChairWimi.find(params[:request])
#    chair_wimi.application = 'accepted'
#
#    if chair_wimi.save
#      ActiveSupport::Notifications.instrument('event', {trigger: current_user.id, target: chair_wimi.user.id, chair: @chair, type: 'EventUserChair', seclevel: :admin, status: 'added'})
#      flash[:success] = I18n.t('chair.accept_request.success')
#    else
#      flash[:error] = I18n.t('chair.accept_request.error')
#    end
#    redirect_to chair_path(@chair)
#  end

  def add_user
    user = User.find_by_id params[:add_user_to_chair][:id]
    redirect_to chair_path(@chair)
    if user.nil?
      flash[:error] = I18n.t('chair.user.add_error')
      return
    elsif @chair.users.include? user
      flash[:notice] = I18n.t('chair.user.already_member', name: user.name)
      return
    end
    chairwimi = ChairWimi.create(application: 'accepted', chair: @chair, user: user)
    if chairwimi.save
      flash[:success] = I18n.t('chair.user.successfully_added', name: user.name)
    else
      flash[:error] = I18n.t('chair.user.add_error')
    end
  end

  def remove_user
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

  private

  def set_chair
    @chair = Chair.find(params[:id])
  end

  def chair_params
    params.require(:chair).permit(:name, :abbreviation, :description)
  end
end
