class ChairsController < ApplicationController
  before_action :set_chair, only: [:show, :edit, :update, :destroy]

  # GET /chairs
  # GET /chairs.json
  def index
    @chairs = Chair.all
  end

  # GET /chairs/1
  # GET /chairs/1.json
  def show
  end

  # GET /chairs/new
  def new
    @chair = Chair.new
  end

  # GET /chairs/1/edit
  def edit
  end

  # POST /chairs
  # POST /chairs.json
  def create
    @chair = Chair.new(chair_params)
    @chair.administrators<<current_user;

    respond_to do |format|
      if @chair.save
        format.html { redirect_to @chair, notice: 'Chair was successfully created.' }
        format.json { render :show, status: :created, location: @chair }
      else
        format.html { render :new }
        format.json { render json: @chair.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chairs/1
  # PATCH/PUT /chairs/1.json
  def update
    respond_to do |format|
      if @chair.update(chair_params)
        format.html { redirect_to @chair, notice: 'Chair was successfully updated.' }
        format.json { render :show, status: :ok, location: @chair }
      else
        format.html { render :edit }
        format.json { render json: @chair.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chairs/1
  # DELETE /chairs/1.json
  def destroy
    @chair.destroy
    respond_to do |format|
      format.html { redirect_to chairs_url, notice: 'Chair was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chair
      @chair = Chair.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chair_params
      params.require(:chair).permit(:name)
    end
end
