class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_action :exclude_nil, :set_user

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to current_user
    else
      render :edit
    end
  end

  private

  def exclude_nil
    if User.where(id: params[:id]).blank?
      redirect_to root_path
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first, :last_name, :residence, :street, :division_id, :personnel_number, :remaining_leave, :remaining_leave_last_year, :language)
  end

end
