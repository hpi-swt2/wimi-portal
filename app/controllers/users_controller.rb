class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user, :get_months

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'User was successfully updated.'
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
    params.require(:user).permit(:first_name, :last_name, :email, :residence, :street, :division_id, :personnel_number, :remaining_leave, :remaining_leave_last_year)
  end

  def get_months
    @year_months = []
    creation_date = current_user.created_at
    (current_user.created_at.year..Date.today.year).each do |year|
      start_month = (creation_date.year == year) ? creation_date.month : 1
      end_month = (Date.today.year == year) ? Date.today.month : 12

      (start_month..end_month).each do |month|
        @year_months.push([year, month])
      end
    end
  end

end
