class ChairsAdministratorsController < ApplicationController
  before_action :set_chairs_administrator, only: [:show, :edit, :update, :destroy]

  # GET /chairs_administrators
  # GET /chairs_administrators.json
  def index
    @chairs_administrators = ChairsAdministrator.all
  end

  # GET /chairs_administrators/1
  # GET /chairs_administrators/1.json
  def show
  end

  # GET /chairs_administrators/new
  def new
    @chairs_administrator = ChairsAdministrator.new
  end

  # GET /chairs_administrators/1/edit
  def edit
  end

  # POST /chairs_administrators
  # POST /chairs_administrators.json
  def create
    @chairs_administrator = ChairsAdministrator.new(chairs_administrator_params)

    respond_to do |format|
      if @chairs_administrator.save
        format.html { redirect_to @chairs_administrator, notice: 'Chairs administrator was successfully created.' }
        format.json { render :show, status: :created, location: @chairs_administrator }
      else
        format.html { render :new }
        format.json { render json: @chairs_administrator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chairs_administrators/1
  # PATCH/PUT /chairs_administrators/1.json
  def update
    respond_to do |format|
      if @chairs_administrator.update(chairs_administrator_params)
        format.html { redirect_to @chairs_administrator, notice: 'Chairs administrator was successfully updated.' }
        format.json { render :show, status: :ok, location: @chairs_administrator }
      else
        format.html { render :edit }
        format.json { render json: @chairs_administrator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chairs_administrators/1
  # DELETE /chairs_administrators/1.json
  def destroy
    @chairs_administrator.destroy
    respond_to do |format|
      format.html { redirect_to chairs_administrators_url, notice: 'Chairs administrator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chairs_administrator
      @chairs_administrator = ChairsAdministrator.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chairs_administrator_params
      params.require(:chairs_administrator).permit(:user_id, :chair_id)
    end
end
