require 'rails_helper'

RSpec.describe "ChairWimis", type: :request do
  describe "GET /chair_wimis" do
    it "works! (now write some real specs)" do
      get chair_wimis_path
      expect(response).to have_http_status(200)
    end
  end
end
