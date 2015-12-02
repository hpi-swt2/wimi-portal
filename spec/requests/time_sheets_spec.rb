require 'rails_helper'

RSpec.describe "TimeSheets", type: :request do
  describe "GET /time_sheets" do
    it "works! (now write some real specs)" do
      get time_sheets_path
      expect(response).to have_http_status(200)
    end
  end
end
