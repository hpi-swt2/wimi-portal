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
    @project = Project.new
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
    @project.destroy_invitations
    @project.destroy
    flash[:success] = t '.success'
    redirect_to projects_url
  end

  def invite_user
    user = User.find_by_email params[:invite_user][:email]
    if user.nil?
      flash[:error] = I18n.t('users.does_not_exist')
      redirect_to @project
    else
      if Invitation.where(project: @project, user: user).size > 0
        flash[:error] = I18n.t('project.user.already_invited')
        redirect_to @project
      else
        if @project.users.include? user
          flash[:error] = I18n.t('project.user.already_is_member')
          redirect_to @project
        else
          @project.add_user user
          if @project.save
            flash[:success] = I18n.t('project.user.was_successfully_invited')
            redirect_to @project
          else
            flash[:error] = I18n.t('project.user.cannot_be_invited')
            redirect_to @project
          end
        end
      end
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
    map.each do |p, d|
      data.push(name: p.title, y: d)
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
