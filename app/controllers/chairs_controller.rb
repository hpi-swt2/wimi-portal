class ChairsController < ApplicationController
  before_action :set_chair, only: [:show, :accept_request, :remove_from_chair, :destroy]

  before_action :authorize_admin, only: [:show, :accept_request, :remove_from_chair]
  before_action :authorize_superadmin, only: [:destroy, :new, :create]

  def index
    @chairs = Chair.all
  end

  # Superadmin tasks:
  def destroy
    @chair.destroy
    respond_to do |format|
      format.html { redirect_to chairs_path, notice: 'Chair was successfully destroyed.' }
      format.json { render json: @chair.errors, status: :unprocessable_entity }
    end
  end

  def new
    @chair = Chair.new
  end

  def create
    @chair = Chair.new(chair_params)

    success = false
    admin = User.find_by(id: params[:admin_user])
    representative = User.find_by(id: params[:representative_user])

    if (admin && representative) && admin != representative
      unless admin.is_wimi? || representative.is_wimi?
        c1 = ChairWimi.new(:admin => true, :chair => @chair, :user => admin, :application => 'accepted')
        c2 = ChairWimi.new(:representative => true, :chair => @chair, :user => representative, :application => 'accepted')
        
        if @chair.save && c1.save && c2.save
          success = true
        end
      end
    end

    respond_to do |format|
      if success
        format.html { redirect_to chairs_path, notice: 'Chair successfully created.' }
        format.json { render :index, status: :created, location: chair_path(@chair) }
      else
        format.html { render :new }
        format.json { render json: @chair.errors, status: :unprocessable_entity }
      end
    end
  end

  # Admin / Representative tasks:
  def show
    @requests = @chair.chair_wimis.where(:application => 'pending')
  end

  def accept_request
    chair_wimi = ChairWimi.find(params[:request])
    chair_wimi.application = 'accepted'

    respond_to do |format|
      if chair_wimi.save
        format.html { redirect_to chair_path(@chair), notice: 'Application was successfully accepted.' }
        format.json { render :show, status: :created, location: chair_path(@chair) }
      else
        format.html { redirect_to chair_path(@chair), notice: 'Accepting application failed' }
        format.json { render json: chair_path(@chair).errors, status: :unprocessable_entity }
      end
    end
  end

  def remove_from_chair
    chair_wimi = ChairWimi.find(params[:request])

    success = false
    unless current_user == chair_wimi.user
      if chair_wimi.destroy
        success = true
      end
    end

    respond_to do |format|
      if success
        format.html { redirect_to chair_path(@chair), notice: 'User was successfully removed.' }
        format.json { render :show, status: :created, location: chair_path(@chair) }
      else
        format.html { redirect_to chair_path(@chair), notice: 'Destroying Chair_wimi failed' }
        format.json { render json: chair_path(@chair).errors, status: :unprocessable_entity }
      end
    end
  end

  # User task:
  def apply
    wimi = ChairWimi.new(:chair_id => params[:chair])
    wimi.user = current_user
    wimi.application = 'pending'

    success = false
    unless ChairWimi.find_by(:user => current_user)
      success = wimi.save
    end

    respond_to do |format|
      if success
        format.html { redirect_to chairs_path, notice: 'Chair wimi application was successfully created.' }
        format.json { render :show, status: :created, location: chairs_path }
      else
        format.html { redirect_to chairs_path, notice: 'Saving failed' }
        format.json { render json: chairs_path.errors, status: :unprocessable_entity }
      end
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