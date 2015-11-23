require 'rails_helper'

RSpec.describe "ChairRepresentatives", type: :request do
  describe "GET /chair_representatives" do
    it "works! (now write some real specs)" do
      get chair_representatives_path
      expect(response).to have_http_status(200)
    end
  end
end
