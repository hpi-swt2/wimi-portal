class UserProfileController < ApplicationController
  before_action :set_profile

  def show
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'User was successfully updated.'
      redirect_to profile_path
    else
      render :show
    end
  end

  private
    def set_profile
      @user = User.find(current_user.id)
    end

    def user_params
      params[:user].permit(User.column_names.map(&:to_sym))
    end
end
