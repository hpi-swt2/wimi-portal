require 'rails_helper'

RSpec.describe "ChairApplications", type: :request do
  describe "GET /chair_applications" do
    it "works! (now write some real specs)" do
      get chair_applications_path
      expect(response).to have_http_status(200)
    end
  end
end
