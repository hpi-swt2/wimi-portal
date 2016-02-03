class UsersController < ApplicationController
  before_filter :authenticate_user!, except: :superadmin_index
  before_action :user_exists, :set_user, except: [:superadmin_index, :language]
  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = t('not_authorized')
    redirect_to dashboard_path
  end

  def show
    @trips = @user.get_desc_sorted_trips
  end

  def edit
  end

  def update
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

  def superadmin_index
    unless current_user.nil?
      flash[:error] = t('.logout_before_access_superadmin_page')
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

  private

  def user_exists
    unless User.find_by(id: params[:id])
      redirect_to root_path
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params[:user].permit(User.column_names.map(&:to_sym))
  end
end
