class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_action :to_current, :set_user, :get_months

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
