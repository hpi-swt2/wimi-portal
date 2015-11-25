class ChairAdminsController < ApplicationController
  before_action :set_chair_admin, only: [:show, :edit, :update, :destroy]

  # GET /chair_admins
  # GET /chair_admins.json
  def index
    @chair_admins = ChairAdmin.all
  end

  # GET /chair_admins/1
  # GET /chair_admins/1.json
  def show
  end

  # GET /chair_admins/new
  def new
    @chair_admin = ChairAdmin.new
  end

  # GET /chair_admins/1/edit
  def edit
  end

  # POST /chair_admins
  # POST /chair_admins.json
  def create
    @chair_admin = ChairAdmin.new(chair_admin_params)

    respond_to do |format|
      if @chair_admin.save
        format.html { redirect_to @chair_admin, notice: 'Chair admin was successfully created.' }
        format.json { render :show, status: :created, location: @chair_admin }
      else
        format.html { render :new }
        format.json { render json: @chair_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chair_admins/1
  # PATCH/PUT /chair_admins/1.json
  def update
    respond_to do |format|
      if @chair_admin.update(chair_admin_params)
        format.html { redirect_to @chair_admin, notice: 'Chair admin was successfully updated.' }
        format.json { render :show, status: :ok, location: @chair_admin }
      else
        format.html { render :edit }
        format.json { render json: @chair_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chair_admins/1
  # DELETE /chair_admins/1.json
  def destroy
    @chair_admin.destroy
    respond_to do |format|
      format.html { redirect_to chair_admins_url, notice: 'Chair admin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chair_admin
      @chair_admin = ChairAdmin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chair_admin_params
      params.require(:chair_admin).permit(:user_id, :chair_id)
    end
end
