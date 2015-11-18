require 'rails_helper'

RSpec.describe "ChairsWimis", type: :request do
  describe "GET /chairs_wimis" do
    it "works! (now write some real specs)" do
      get chairs_wimis_path
      expect(response).to have_http_status(200)
    end
  end
end
