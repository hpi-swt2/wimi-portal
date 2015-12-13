class ProjectApplicationsController < ApplicationController
  before_action :set_project_application, only: [:destroy, :accept, :decline, :reapply]

  # GET /project_applications
  # GET /project_applications.json
  def index
    @project_applications = current_user.project_applications.order(updated_at: :desc)
  end

  def accept
    @project_application.update(status: :accepted)
    user = @project_application.user
    user.projects << @project_application.project
    redirect_to :back
  end

  def decline
    @project_application.update_attributes(status: :declined)
    redirect_to :back
  end

  def reapply
    @project_application.update(status: :pending)
    redirect_to :back
  end

  # POST /project_applications
  # POST /project_applications.json
  def create
    @project_application = ProjectApplication.new
    @project_application.user_id = current_user.id
    @project_application.project_id = params[:id]

    respond_to do |format|
      if @project_application.save
        format.html { redirect_to project_applications_path, notice: 'Project application was successfully created.' }
        format.json { render :show, status: :created, location: @project_application }
      else
        format.html { redirect_to project_applications_path, notice: 'Project application wasn\'t created.' }
        format.json { render json: @project_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_applications/1
  # DELETE /project_applications/1.json
  def destroy
    @project_application.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Project application was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_application
      @project_application = ProjectApplication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_application_params
      params.permit(:project_id, :user_id)
    end
end
