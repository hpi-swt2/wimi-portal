class ProjectsController < ApplicationController
  load_and_authorize_resource
  before_action :set_project, only: [:show, :edit, :update, :destroy, :invite_user, :remove_user, :accept_invitation, :decline_invitation]

  has_scope :title
  has_scope :chair

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = I18n.t('not_authorized')
    redirect_to dashboard_path
  end

  def index
    @projects = apply_scopes(Project.all)
  end

  def show
  end

  def new
    @project = Project.new
    @project.invitations.build
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      @project.update(chair: current_user.chair)
      current_user.projects << @project
      flash[:success] = 'Project was successfully created.'
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
          if @project.invite_user user, current_user
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

  def sign_user_out
    user = User.find(params[:user_id])
    @project = Project.find(params[:id])
    if can?(:edit, @project) || current_user == user
      @project.remove_user(user)
      if user == current_user
        redirect_to projects_path
      else
        redirect_to edit_project_path(@project)
      end
    else
      redirect_to dashboard_path
      flash[:error] = I18n.t('project.user.not_authorized')
    end
  end

  def accept_invitation
    if @project.add_user current_user
      @project.destroy_invitation current_user
      flash[:success] = I18n.t('project.user.invitation_accepted')
      redirect_to dashboard_path
    else
      @project.destroy_invitation current_user
      flash[:error] = I18n.t('project.user.cannot_be_invited')
      redirect_to dashboard_path
    end
  end

  def decline_invitation
    @project.destroy_invitation current_user
    flash[:success] = I18n.t('project.user.invitation_declined')
    redirect_to root_path
  end

  def typeahead
    @search = UserSearch.new(typeahead: params[:query])
    render json: @search.results
  end

  def hiwi_working_hours
    month = params[:month_year].split('-')[0]
    year = params[:month_year].split('-')[1]
    month.to_i
    year.to_i
    render json: {msg: Project.working_hours_data(year, month)}
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
