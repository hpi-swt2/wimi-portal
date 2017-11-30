class ProjectsController < ApplicationController
  load_and_authorize_resource

  has_scope :title
  has_scope :chair

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = t('not_authorized')
    redirect_to dashboard_path
  end

  def index
    # If there is only one project available to view to a user and
    # no permissions are available to create one (which is possible on the index page)
    # then redirect directly to the show page of the only project.
    if @projects.count == 1 and current_ability.cannot?(:new, Project)
      redirect_to project_path(@projects.first)
    else
      @projects = apply_scopes(@projects)
    end
  end

  def show
    @recent_events = Event.recent_events_for(@project)
  end

  def new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    @project.chair = current_user.chair
    if @project.save
      Event.add(:project_create, current_user, @project, current_user)
      current_user.projects << @project
      flash[:success] = t '.success'
      redirect_to @project
    else
      render :new
    end
  end

  def update
    if @project.update(project_params)
      flash[:success] = t '.success'
      redirect_to @project
    else
      render :edit
    end
  end

  def destroy
    if @project.destroy
      flash[:success] = t '.success'
      redirect_to projects_url
    else
      render :edit
    end
  end

  def add_user
    user = User.find_by_id params[:add_user_to_project][:id]
    redirect_to @project
    if user.nil?
      flash[:error] = I18n.t('project.user.add_error')
      return
    elsif @project.users.include? user
      flash[:notice] = I18n.t('project.user.already_member', name: user.name)
      return
    end
    @project.users << user
    if @project.save
      Event.add(:project_join, current_user, @project, user)
      flash[:success] = I18n.t('project.user.successfully_added', name: user.name)
    else
      flash[:error] = I18n.t('project.user.add_error')
    end
  end

  def toggle_status
    @project = Project.find(params[:id])
    if @project.status
      @project.update(status: false)
    else
      @project.update(status: true)
    end
    @project.reload
    redirect_to project_path(@project)
  end
  
  def leave
    @project.remove_user(current_user)
    redirect_to dashboard_path
  end

  def remove_user
    user = User.find(params[:user])
    if user.is_wimi? and @project.wimis.count <= 1
      redirect_to dashboard_path
      flash[:error] = I18n.t('project.user.last_wimi')
    else
      if can?(:edit, @project) || current_user == user
        @project.remove_user(user)
        Event.add(:project_leave, current_user, @project, user)
        if user == current_user
          redirect_to projects_path
        else
          redirect_to edit_project_path(@project)
        end
      else
        redirect_to dashboard_path
        flash[:error] = I18n.t('project.not_authorized')
      end
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params[:project].permit(Project.column_names.map(&:to_sym), {user_ids: []})
  end
end
