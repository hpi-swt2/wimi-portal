require 'rails_helper'

RSpec.describe ChairsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      login_with create(:user)
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
