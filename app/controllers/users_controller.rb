class UsersController < ApplicationController
  #before_filter :authenticate_user!, except: :external_login
#  before_action :user_exists, except: [:external_login, :language]
  
  load_and_authorize_resource
  skip_authorize_resource :only => [:external_login]

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = t('not_authorized')
    redirect_to dashboard_path
  end

  def index
    @users = User.all
    render :layout => 'no_sidebar'
  end

  def show
    @trips = @user.get_desc_sorted_trips
    @recent_events = Event.where("user_id=? or target_user_id=?", @user.id, @user.id)
      .limit(5)
      .order(created_at: :desc)
      .select { |e| current_ability.can?(:show, e) }
  end

  def edit
  end

  def update
    if event_settings.any?
      event_params = event_settings[:event_settings]
      @user.update(event_settings: event_params.map(&:to_i))
    else
      # When no notification checkboxes are selected, event_settings is empty
      # except when the language is changed
      unless user_params.has_key?(:language)
        @user.clear_event_settings
      end
    end
    if @user.update(user_params)
      I18n.locale = @user.language

      if user_params.has_key?(:language)
        flash[:success] = t('.user_updated_language')
        redirect_to :back
      else
        flash[:success] = t('.user_updated')
        redirect_to current_user
      end
    else
      render :edit
    end
    rescue ActionController::RedirectBackError
      redirect_to current_user
  end

  def external_login
    unless current_user.nil?
      redirect_to root_path
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  helper_method :resource, :resource_name, :devise_mapping

  def language
    render json: {msg: current_user.language}
  end

  def upload_signature
    if params[:upload]
      file = Base64.encode64(params[:upload]['datafile'].read)
      file_name = params[:upload]['datafile'].original_filename
      file_type = file_name.split('.').last.to_s
      if %w[jpg bmp jpeg png].include? file_type.downcase
        @user.update(signature: file)
        flash[:success] = t('.upload_success')
      else
        flash[:error] = t('.invalid_file_extension')
      end
    else
      flash[:error] = t('.upload_error')
    end
    redirect_to current_user
  end

  def delete_signature
    @user.update(signature: nil)
    flash[:success] = t('.destroy_success')
    redirect_to current_user
  end
  
  def autocomplete
    search = UserSearch.new(user: params[:query])
    render json: search.results.select('id', 'email', 'first_name', 'last_name', 'username')
  end

  private

  def user_params
    params[:user].permit(User.column_names.map(&:to_sym))
  end

  def event_settings
    params[:user].permit(event_settings: [])
  end
end
