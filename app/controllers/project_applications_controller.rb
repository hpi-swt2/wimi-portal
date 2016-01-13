class ProjectApplicationsController < ApplicationController
  before_action :set_project_application, only: [:destroy, :accept, :decline, :reapply]

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

  def create
    @project_application = ProjectApplication.new
    @project_application.user_id = current_user.id
    @project_application.project_id = params[:id]

    if @project_application.save
      redirect_to project_applications_path
      flash[:success] = I18n.t('project_applications.created')
    else
      redirect_to project_applications_path
      flash[:error] = I18n.t('project_applications.not_created')
    end
  end

  def destroy
    @project_application.destroy
    flash[:success] = I18n.t('project_applications.destroy')
    redirect_to :back
  end

  private

  def set_project_application
    @project_application = ProjectApplication.find(params[:id])
  end

  def project_application_params
    params.permit(:project_id, :user_id)
  end
end
