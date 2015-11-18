require 'rails_helper'

RSpec.describe UserProfileController, type: :controller do

  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response.headers['Location']).to eq('http://' + @request.host + new_user_session_path)
    end
  end

  describe "GET #update" do
    it "returns http success" do
      get :update
      expect(response.headers['Location']).to eq('http://' + @request.host + new_user_session_path)
    end
  end

end
