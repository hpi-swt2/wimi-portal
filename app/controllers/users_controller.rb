class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_action :user_exists, :set_user

  def show
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
    params.require(:user).permit(:first, :last_name, :email, :residence, :street, :division_id, :personnel_number, :remaining_leave, :remaining_leave_last_year, :language)
  end
end
