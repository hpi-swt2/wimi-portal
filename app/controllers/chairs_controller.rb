class ChairsController < ApplicationController
  before_action :set_chair, only: [:show, :accept_request, :remove_from_chair, :destroy, :requests]

  before_action :authorize_admin, only: [:show, :accept_request, :remove_from_chair, :set_admin, :withdraw_admin]
  before_action :authorize_superadmin, only: [:destroy, :new, :create]


  def index
    @chairs = Chair.all
  end

  # Superadmin tasks:
  def destroy
    if @chair.destroy
      redirect_to chairs_path, notice: 'Chair was successfully destroyed.'
    end
  end

  def new
    @chair = Chair.new
  end

  def create
    @chair = Chair.new(chair_params)
    
    if @chair.add_users(params[:admin_user], params[:representative_user])
      redirect_to chairs_path, notice: 'Chair successfully created.'
    else
      render :new
    end
  end

  # Admin / Representative tasks:
  def show
    @requests = @chair.chair_wimis.where(application: 'pending')
  end

  def accept_request
    chair_wimi = ChairWimi.find(params[:request])
    chair_wimi.application = 'accepted'

    if chair_wimi.save
      redirect_to chair_path(@chair), notice: 'Application was successfully accepted.'
    else
      redirect_to chair_path(@chair), notice: 'Accepting application failed'
    end
  end

  def remove_from_chair
    chair_wimi = ChairWimi.find(params[:request])

    if chair_wimi.remove(current_user)
      redirect_to chair_path(@chair), notice: 'User was successfully removed.'
    else
      redirect_to chair_path(@chair), notice: 'Destroying Chair_wimi failed'
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
      redirect_to chairs_path, notice: 'Chair wimi application was successfully created.'
    else
      redirect_to chairs_path, notice: 'Saving failed'
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
    unless current_user.superadmin
      not_authorized
    end
  end

  def authorize_admin
    c_wimi = current_user.chair_wimi
    if c_wimi.nil?
      not_authorized
    else
      unless (c_wimi.admin == true || c_wimi.representative == true) && c_wimi.chair == @chair
        not_authorized
      end
    end
  end


  def not_authorized
    redirect_to root_path, notice: 'Not authorized for this chair.'
  end
end