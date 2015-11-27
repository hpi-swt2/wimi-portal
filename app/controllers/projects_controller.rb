class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :invite_user]

  def index
    @projects = Project.all
  end

  def show
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      flash[:success] = 'Project was successfully created.'
      redirect_to @project
    else
      render :new
    end
  end

  def update
    if @project.update(project_params)
      flash[:success] = 'Project was successfully updated.'
      redirect_to @project
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    flash[:success] = 'Project was successfully destroyed.'
    redirect_to projects_url
  end

  def invite_user
    @project.add_user params[:invite_user][:email]
    flash[:success] = "Der Benutzer wurde erfolgreich zum Projekt hinzugefügt."
    render :show
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params[:project].permit(Project.column_names.map(&:to_sym), { user_ids:[] })
    end
end
