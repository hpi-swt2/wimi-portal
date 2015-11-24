class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_action :to_current, :set_user

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to current_user
    else
      redirect_to root_path
    end
  end

  private

  def to_current
    if(current_user != User.find(params[:id]))
      redirect_to root_path
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first, :last_name, :residence, :street, :division, :number)
  end

end
