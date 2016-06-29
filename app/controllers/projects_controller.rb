class ProjectsController < ApplicationController
  load_and_authorize_resource
  skip_load_and_authorize_resource only: :create

  has_scope :title
  has_scope :chair

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = t('not_authorized')
    redirect_to dashboard_path
  end

  def index
    @projects = apply_scopes(@projects)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    @project.chair = current_user.chair
    if can?(:create, @project) and @project.save
      current_user.projects << @project
      flash[:success] = t '.success'
      unless params[:invitations].blank?
        params[:invitations].values.each do |email|
          user = User.find_by_email(email)
          unless user.nil? or Invitation.where(project: @project, user: user).size > 0 or @project.users.include? user
            @project.invite_user user, current_user
          end
        end
      end
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

  def hiwi_working_hours
    month = params[:month_year].split('-')[0].to_i
    year = params[:month_year].split('-')[1].to_i
    
    map = {}
    WorkDay.month(month, year).each do |wd|
      map[wd.project] = wd.duration + (map[wd.project] || 0)
    end
    
    data = []
    map.each do |project, total_work_time|
      data.push(name: project.title, y: total_work_time.round)
    end
    
    render json: {msg: data}
    rescue
      render json: {msg: {y: 0, name: I18n.t('activerecord.errors.try_again_later')}}
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params[:project].permit(Project.column_names.map(&:to_sym), {user_ids: []})
  end
end
