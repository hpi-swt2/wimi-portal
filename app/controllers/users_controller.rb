class UsersController < ApplicationController
  before_filter :authenticate_user!, except: :superadmin_index
  before_action :user_exists, :set_user, except: [:superadmin_index, :language]

  def show
    @datespans = @user.get_desc_sorted_datespans
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = t('.user_updated')
      redirect_to current_user
    else
      render :edit
    end
  end

  def superadmin_index
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
