require 'rails_helper'

RSpec.describe "ChairsCandidates", type: :request do
  describe "GET /chairs_candidates" do
    it "works! (now write some real specs)" do
      get chairs_candidates_path
      expect(response).to have_http_status(200)
    end
  end
end
