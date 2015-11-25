class ChairWimisController < ApplicationController
  before_action :set_chair_wimi, only: [:show, :edit, :update, :destroy]

  # GET /chair_wimis
  # GET /chair_wimis.json
  def index
    @chair_wimis = ChairWimi.all
  end

  # GET /chair_wimis/1
  # GET /chair_wimis/1.json
  def show
  end

  # GET /chair_wimis/new
  def new
    @chair_wimi = ChairWimi.new
  end

  # GET /chair_wimis/1/edit
  def edit
  end

  # POST /chair_wimis
  # POST /chair_wimis.json
  def create
    @chair_wimi = ChairWimi.new
    @chair_wimi.chair_id = params[:chair]
    @chair_wimi.user_id = params[:user]

    @chairapp = ChairApplication.find_by(:user_id => params[:user], :chair_id => params[:chair])
    logger.debug @chairapp.id
    @chairapp.status = 'accepted'
    @chairapp.save

    respond_to do |format|
      if @chair_wimi.save
        format.html { redirect_to @chair_wimi, notice: 'Chair wimi was successfully created.' }
        format.json { render :show, status: :created, location: @chair_wimi }
      else
        format.html { render :new }
        format.json { render json: @chair_wimi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chair_wimis/1
  # PATCH/PUT /chair_wimis/1.json
  def update
    respond_to do |format|
      if @chair_wimi.update(chair_wimi_params)
        format.html { redirect_to @chair_wimi, notice: 'Chair wimi was successfully updated.' }
        format.json { render :show, status: :ok, location: @chair_wimi }
      else
        format.html { render :edit }
        format.json { render json: @chair_wimi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chair_wimis/1
  # DELETE /chair_wimis/1.json
  def destroy
    @chair_wimi.destroy
    respond_to do |format|
      format.html { redirect_to chair_wimis_url, notice: 'Chair wimi was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chair_wimi
      @chair_wimi = ChairWimi.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chair_wimi_params
      params.require(:chair_wimi).permit(:user_id, :chair_id)
    end
end
