require 'rails_helper'

RSpec.describe "Chairs", type: :request do
  describe "GET /chairs" do
    xit "works! (now write some real specs)" do
      get chairs_path
      expect(response).to have_http_status(200)
    end
  end
end
