class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_action :user_exists, :set_user, except: :language

  def show
    @datespans = current_user.get_desc_sorted_datespans
  end

  def edit
  end

  def update
    if @user.update(user_params)
      I18n.locale = @user.language
      flash[:success] = t('.user_updated')
      redirect_to current_user
    else
      render :edit
    end
  end

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
    params.require(:user).permit(:first_name, :last_name, :email, :residence, :street, :personnel_number, :remaining_leave, :remaining_leave_last_year, :language)
  end
end
