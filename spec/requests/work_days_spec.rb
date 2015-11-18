require 'rails_helper'

RSpec.describe "WorkDays", type: :request do
  describe "GET /work_days" do
    it "works! (now write some real specs)" do
      get work_days_path
      expect(response).to have_http_status(200)
    end
  end
end
