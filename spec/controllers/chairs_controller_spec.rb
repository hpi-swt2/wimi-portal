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

    it 'tries to remove admin' do
      login_with @admin
      post :remove_from_chair, {id: @chair, request: @admin.chair_wimi}
      expect(User.find(@wimi.id).is_wimi?).to eq(true)
    end

    it 'accepts application request' do
      wimi_count = @chair.wimis.count
      login_with @user
      post :apply, {chair: @chair}
      login_with @admin
      post :accept_request, {id: @chair, request: ChairWimi.find_by(user: @user)}
      expect(Chair.find(@chair.id).wimis.count).to eq(wimi_count+1)
    end
  end


  describe 'GET #new' do
    before(:each) do
      @superadmin = FactoryGirl.create(:user)
      @superadmin.superadmin = true
      @user = FactoryGirl.create(:user)
    end

    it 'returns Chairs page for superadmin' do
      login_with @superadmin
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'returns dashboard page for user' do
      login_with @user
      get :new
      expect(response).to have_http_status(302)
    end
  end
  
  describe 'POST #create' do
    before(:each) do
      @superadmin = FactoryGirl.create(:user)
      @superadmin.superadmin = true
      @user = FactoryGirl.create(:user)
    end

    it 'creates a new Chair' do
      user1 = FactoryGirl.create(:user)
      login_with @superadmin
      expect {
        post :create, { :chair => {:name => 'Test'}, :admin_user => @user, :representative_user => user1}
      }.to change(Chair, :count).by(1)
    end
  end
end