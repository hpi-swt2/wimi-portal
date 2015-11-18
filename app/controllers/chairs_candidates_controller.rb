class ChairsCandidatesController < ApplicationController
  before_action :set_chairs_candidate, only: [:show, :edit, :update, :destroy]

  # GET /chairs_candidates
  # GET /chairs_candidates.json
  def index
    @chairs_candidates = ChairsCandidate.all
  end

  # GET /chairs_candidates/1
  # GET /chairs_candidates/1.json
  def show
  end

  # GET /chairs_candidates/new
  def new
    @chairs_candidate = ChairsCandidate.new
  end

  # GET /chairs_candidates/1/edit
  def edit
  end

  # POST /chairs_candidates
  # POST /chairs_candidates.json
  def create
    @chairs_candidate = ChairsCandidate.new(chairs_candidate_params)

    respond_to do |format|
      if @chairs_candidate.save
        format.html { redirect_to @chairs_candidate, notice: 'Chairs candidate was successfully created.' }
        format.json { render :show, status: :created, location: @chairs_candidate }
      else
        format.html { render :new }
        format.json { render json: @chairs_candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chairs_candidates/1
  # PATCH/PUT /chairs_candidates/1.json
  def update
    respond_to do |format|
      if @chairs_candidate.update(chairs_candidate_params)
        format.html { redirect_to @chairs_candidate, notice: 'Chairs candidate was successfully updated.' }
        format.json { render :show, status: :ok, location: @chairs_candidate }
      else
        format.html { render :edit }
        format.json { render json: @chairs_candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chairs_candidates/1
  # DELETE /chairs_candidates/1.json
  def destroy
    @chairs_candidate.destroy
    respond_to do |format|
      format.html { redirect_to chairs_candidates_url, notice: 'Chairs candidate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chairs_candidate
      @chairs_candidate = ChairsCandidate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chairs_candidate_params
      params.require(:chairs_candidate).permit(:user_id, :chair_id)
    end
end
