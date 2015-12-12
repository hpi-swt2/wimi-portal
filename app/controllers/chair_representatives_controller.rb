class ChairRepresentativesController < ApplicationController
  before_action :set_chair_representative, only: [:show, :edit, :update, :destroy]

  # GET /chair_representatives
  # GET /chair_representatives.json
  def index
    @chair_representatives = ChairRepresentative.all
  end

  # GET /chair_representatives/1
  # GET /chair_representatives/1.json
  def show
  end

  # GET /chair_representatives/new
  def new
    @chair_representative = ChairRepresentative.new
  end

  # GET /chair_representatives/1/edit
  def edit
  end

  # POST /chair_representatives
  # POST /chair_representatives.json
  def create
    @chair_representative = ChairRepresentative.new(chair_representative_params)

    respond_to do |format|
      if @chair_representative.save
        format.html { redirect_to @chair_representative, notice: 'Chair representative was successfully created.' }
        format.json { render :show, status: :created, location: @chair_representative }
      else
        format.html { render :new }
        format.json { render json: @chair_representative.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chair_representatives/1
  # PATCH/PUT /chair_representatives/1.json
  def update
    respond_to do |format|
      if @chair_representative.update(chair_representative_params)
        format.html { redirect_to @chair_representative, notice: 'Chair representative was successfully updated.' }
        format.json { render :show, status: :ok, location: @chair_representative }
      else
        format.html { render :edit }
        format.json { render json: @chair_representative.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chair_representatives/1
  # DELETE /chair_representatives/1.json
  def destroy
    @chair_representative.destroy
    respond_to do |format|
      format.html { redirect_to chair_representatives_url, notice: 'Chair representative was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chair_representative
      @chair_representative = ChairRepresentative.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chair_representative_params
      params.require(:chair_representative).permit(:user_id, :chair_id)
    end
end
