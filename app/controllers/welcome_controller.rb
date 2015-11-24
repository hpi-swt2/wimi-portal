class WelcomeController < ApplicationController
  before_action :get_months

  def index
  end

  private

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
