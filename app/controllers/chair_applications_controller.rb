class ChairApplicationsController < ApplicationController
  before_action :set_chair_application, only: [:show, :edit, :update, :destroy]

  # GET /chair_applications
  # GET /chair_applications.json
  def index
    @chair_applications = ChairApplication.all
  end

  # GET /chair_applications/1
  # GET /chair_applications/1.json
  def show
  end

  # GET /chair_applications/new
  def new
    @chair_application = ChairApplication.new
  end

  # GET /chair_applications/1/edit
  def edit
  end

  # POST /chair_applications
  # POST /chair_applications.json
  def create
    @chair_application = ChairApplication.new
    @chair_application.user_id = current_user.id
    @chair_application.chair_id = params[:chair]

    respond_to do |format|
      if @chair_application.save
        format.html { redirect_to chairs_path, notice: 'Your chair application was saved successfully!' }
        format.json { render :show, status: :created, location: chairs_path }
      else
        format.html { render :new }
        format.json { render json: @chair_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chair_applications/1
  # PATCH/PUT /chair_applications/1.json
  def update
    respond_to do |format|
      if @chair_application.update(chair_application_params)
        format.html { redirect_to @chair_application, notice: 'Chair application was successfully updated.' }
        format.json { render :show, status: :ok, location: @chair_application }
      else
        format.html { render :edit }
        format.json { render json: @chair_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chair_applications/1
  # DELETE /chair_applications/1.json
  def destroy
    @chair_application.destroy
    respond_to do |format|
      format.html { redirect_to chairs_path, notice: 'You canceled your application successfully!' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chair_application
      @chair_application = ChairApplication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chair_application_params
      params.require(:chair_application).permit(:user_id, :chair_id, :status)
    end
end
