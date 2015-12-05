require 'rails_helper'

RSpec.describe ChairsController, type: :controller do

  describe 'GET #index' do
    before(:each) do
      @chair = FactoryGirl.create(:chair)
      @admin = FactoryGirl.create(:user)
      ChairWimi.create(:user => @admin, :chair => @chair, :admin => true, :application => 'accepted')
      @wimi = FactoryGirl.create(:user)
      ChairWimi.create(:user => @wimi, :chair => @chair, :application => 'accepted')
      @user = FactoryGirl.create(:user)
    end

    it 'shows index of all chairs' do
      login_with(@user)
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns http success as admin' do
      login_with(@admin)
      get :show, {id: @chair}
      expect(response).to have_http_status(:success)
    end

    it 'redirects to root as not authorized user / wimi' do
      login_with(@user)
      get :show, {id: @chair}
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(root_path)

      login_with(@wimi)
      get :show, {id: @chair}
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(root_path)
    end

    it 'creates a new Wimi application' do
      login_with @user
      expect {
        post :apply, {chair: @chair}
      }.to change(ChairWimi, :count).by(1)

      # a user has 0..1 applications
      expect {
        post :apply, {chair: @chair}
      }.to change(ChairWimi, :count).by(0)
    end

    it 'removes wimi from chair' do
      login_with @admin
      post :remove_from_chair, {id: @chair, request: @wimi.chair_wimi}
      expect(User.find(@wimi.id).is_wimi?).to eq(false)
    end

    it 'tries to remove himself' do
      login_with @admin
      post :remove_from_chair, {id: @chair, request: @admin.chair_wimi}
      expect(User.find(@wimi.id).is_wimi?).to eq(true)
    end

    it 'accepts application request' do
      login_with @user
      post :apply, {chair: @chair}
      login_with @admin
      post :accept_request, {id: @chair, request: ChairWimi.find_by(user: @user)}
      expect(User.find(@user.id).is_wimi?).to eq(true)
    end
  end
end