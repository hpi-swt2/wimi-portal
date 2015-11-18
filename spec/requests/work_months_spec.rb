require 'rails_helper'

RSpec.describe "WorkMonths", type: :request do
  describe "GET /work_months" do
    it "works! (now write some real specs)" do
      get work_months_path
      expect(response).to have_http_status(200)
    end
  end
end
