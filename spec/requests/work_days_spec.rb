require 'rails_helper'

RSpec.describe "WorkDays", type: :request do
  describe "GET /work_days" do
    it "should redirect to the work_days_path with the current date" do
      get work_days_path
      expect(response).to have_http_status(302)
    end
  end

  describe "GET /work_days" do
    it "should show the work hours for January 2015" do
      get work_days_path, {:month => 1, :year => 2015}
      expect(response).to have_http_status(200) #test seems broken
    end
  end
end
