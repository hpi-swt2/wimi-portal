class ChairsWimisController < ApplicationController
  before_action :set_chairs_wimi, only: [:show, :edit, :update, :destroy]

  # GET /chairs_wimis
  # GET /chairs_wimis.json
  def index
    @chairs_wimis = ChairsWimi.all
  end

  # GET /chairs_wimis/1
  # GET /chairs_wimis/1.json
  def show
  end

  # GET /chairs_wimis/new
  def new
    @chairs_wimi = ChairsWimi.new
  end

  # GET /chairs_wimis/1/edit
  def edit
  end

  # POST /chairs_wimis
  # POST /chairs_wimis.json
  def create
    @chairs_wimi = ChairsWimi.new(chairs_wimi_params)

    respond_to do |format|
      if @chairs_wimi.save
        format.html { redirect_to @chairs_wimi, notice: 'Chairs wimi was successfully created.' }
        format.json { render :show, status: :created, location: @chairs_wimi }
      else
        format.html { render :new }
        format.json { render json: @chairs_wimi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chairs_wimis/1
  # PATCH/PUT /chairs_wimis/1.json
  def update
    respond_to do |format|
      if @chairs_wimi.update(chairs_wimi_params)
        format.html { redirect_to @chairs_wimi, notice: 'Chairs wimi was successfully updated.' }
        format.json { render :show, status: :ok, location: @chairs_wimi }
      else
        format.html { render :edit }
        format.json { render json: @chairs_wimi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chairs_wimis/1
  # DELETE /chairs_wimis/1.json
  def destroy
    @chairs_wimi.destroy
    respond_to do |format|
      format.html { redirect_to chairs_wimis_url, notice: 'Chairs wimi was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chairs_wimi
      @chairs_wimi = ChairsWimi.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chairs_wimi_params
      params.require(:chairs_wimi).permit(:user_id, :chair_id)
    end
end
