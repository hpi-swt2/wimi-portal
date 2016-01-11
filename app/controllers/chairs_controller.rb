class ChairsController < ApplicationController

  load_and_authorize_resource
  before_action :set_chair, only: [:show, :accept_request, :remove_from_chair, :destroy, :update, :set_admin, :withdraw_admin, :requests]

  rescue_from CanCan::AccessDenied do |exception|
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
      redirect_to chairs_path
    else
      flash[:error] = I18n.t('chair.destroy.error')
      redirect_to chairs_path
    end
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

  # Admin / Representative tasks:
  def show
    @requests = @chair.chair_wimis.where(application: 'pending')
  end

  # Admin tasks:
  def accept_request
    chair_wimi = ChairWimi.find(params[:request])
    chair_wimi.application = 'accepted'

    if chair_wimi.save
      flash[:success] = I18n.t('chair.accept_request.success')
      redirect_to chair_path(@chair)
    else
      flash[:error] = I18n.t('chair.accept_request.error')
      redirect_to chair_path(@chair)
    end
  end

  def remove_from_chair
    chair_wimi = ChairWimi.find(params[:request])

    if chair_wimi.remove(current_user)
      flash[:success] = I18n.t('chair.remove_from_chair.success')
      redirect_to chair_path(@chair)
    else
      flash[:error] = I18n.t('chair.remove_from_chair.error')
      redirect_to chair_path(@chair)
    end
  end


  # New stuff here


  def requests
    @types = ['holidays', 'expenses', 'trips']
    @statuses = ['applied', 'accepted', 'declined']

    create_allrequests
  end

  def requests_filtered
    @types = Array.new
    @types << 'holidays' if params.has_key?('holiday_filter')
    @types << 'expenses' if params.has_key?('expense_filter')
    @types << 'trips' if params.has_key?('trip_filter')

    @statuses = Array.new
    @statuses << 'applied' if params.has_key?('applied_filter')
    @statuses << 'accepted' if params.has_key?('accepted_filter')
    @statuses << 'declined' if params.has_key?('declined_filter')

    create_allrequests
    render 'requests'
  end

  def add_requests(type, array)
    array.each do |r|
      if @statuses.include? r.status
        @allrequests << {name: r.user.name, type: type, handed_in: r.created_at, status: r.status, action: r}
      end
    end
  end


  def set_admin
    chair_wimi = ChairWimi.find(params[:request])
    chair_wimi.admin = true

    if chair_wimi.save
      flash[:success] = I18n.t('chair.set_admin.success')
      redirect_to chair_path(@chair)
    else
      flash[:error] = I18n.t('chair.set_admin.error')
      redirect_to chair_path(@chair)
    end
  end

  def withdraw_admin
    chair_wimi = ChairWimi.find(params[:request])
    if chair_wimi.withdraw_admin(current_user)
      flash[:success] = I18n.t('chair.withdraw.success')
      redirect_to chair_path(@chair)
    else
      flash[:error] = I18n.t('chair.withdraw.error')
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
      flash[:success] = I18n.t('chair.apply.success')
      redirect_to chairs_path
    else
      flash[:error] = I18n.t('chair.apply.error')
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


  def create_allrequests
    @allrequests = Array.new

    @chair.users.each do |user|
      add_requests('Holiday Request', user.holidays) if @types.include? 'holidays'
      add_requests('Expense Request', user.expenses) if @types.include? 'expenses'
      add_requests('Trip Request', user.trips) if @types.include? 'trips'
    end

    @allrequests = @allrequests.sort_by { |v| v[:handed_in] }.reverse
  end

end