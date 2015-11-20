require 'rails_helper'

RSpec.describe "ProjectApplications", type: :request do
  describe "GET /project_applications" do
    it "works! (now write some real specs)" do
      get project_applications_path
      expect(response).to have_http_status(200)
    end
  end
end
