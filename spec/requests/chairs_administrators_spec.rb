require 'rails_helper'

RSpec.describe "ChairsAdministrators", type: :request do
  describe "GET /chairs_administrators" do
    it "works! (now write some real specs)" do
      get chairs_administrators_path
      expect(response).to have_http_status(200)
    end
  end
end
