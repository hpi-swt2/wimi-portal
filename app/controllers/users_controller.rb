class UsersController < ApplicationController
  before_action :to_current, :set_user

  def show
  end

  def edit
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

end
