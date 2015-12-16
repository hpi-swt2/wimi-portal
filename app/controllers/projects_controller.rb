class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :invite_user, :accept_invitation, :decline_invitation]

  has_scope :title
  has_scope :chair

  def index
    @projects = apply_scopes(Project.all)
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
      flash[:error] = I18n.t('project.user.doesnt_exist', default: 'The user does not exist.')
      redirect_to @project
    else
      if Invitation.where(project: @project, user: user).size > 0
        flash[:error] = I18n.t('project.user.already_invited', default: 'The user is already invited.')
        redirect_to @project
      else
        if @project.users.include? user
          flash[:error] = I18n.t('project.user.already_is_member', default: 'The user is already member of this project.')
          redirect_to @project
        else
          @project.invite_user user
          flash[:success] = I18n.t('project.user.was_successfully_invited', default: 'The user has been invited to this project successfully.')
          redirect_to @project
        end
      end
    end
  end

  def accept_invitation
    @project.add_user current_user
    @project.destroy_invitation current_user
    flash[:success] = I18n.t('project.user.invitation_accepted', default: 'You are now a member of this project!')
    redirect_to @project
  end

  def decline_invitation
    @project.destroy_invitation current_user
    flash[:success] = I18n.t('project.user.invitation_declined', default: 'The invitation was declined.')
    redirect_to root_path
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
