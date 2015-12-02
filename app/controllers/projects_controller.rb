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
    user = User.find_by_email params[:invite_user][:email]
    if user.nil?
      flash[:error] = 'Der Benutzer existiert nicht'
      redirect_to @project
    else
      if @project.users.include? user
        flash[:error] = 'Der Benutzer ist bereits Mitglied dieses Projekts'
        redirect_to @project
      else
        @project.add_user user
        flash[:success] = 'Der Benutzer wurde erfolgreich zum Projekt hinzugefügt.'
        redirect_to @project
      end
    end
  end

  def typeahead
    @search = UserSearch.new(typeahead: params[:query])
    render json: @search.results
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params[:project].permit(Project.column_names.map(&:to_sym), { user_ids:[] })
    end
end
