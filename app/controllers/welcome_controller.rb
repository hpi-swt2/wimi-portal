class WelcomeController < ApplicationController
  before_action :check_months

  def index
  end

  private

  def check_months
      @user_work_months = current_user.work_months.all
      #check for each month since the creation of the user if it exists
      creation_date = current_user.created_at
      (current_user.created_at.year..Date.today.year).each do |year|
          start_month = (creation_date.year == year) ? creation_date.month : 1
          end_month = (Date.today.year == year) ? Date.today.month : 12

          (start_month..end_month).each do |month|
              month_name = Date::MONTHNAMES[month]
              unless WorkMonth.exists?(:user_id => current_user, :name => month_name, :year => year)
                  m = WorkMonth.new
                  m.user_id = current_user.id
                  m.name = month_name
                  m.year = year
                  m.save
              end
          end
      end
  end
end
