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
      @superadmin = FactoryGirl.create(:user)
      @superadmin.superadmin = true
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

    it 'redirects to root as not authorized user / wimi / superadmin' do
      login_with(@user)
      get :show, {id: @chair}
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(chairs_path)

      login_with(@wimi)
      get :show, {id: @chair}
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(chairs_path)

      login_with(@superadmin)
      get :show, {id: @chair}
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(chairs_path)
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

    it 'sets admin and withdraws' do
      login_with @admin
      post :set_admin, {id: @chair, request: ChairWimi.find_by(user: @wimi)}
      expect(User.find(@wimi.id).is_admin?(@chair)).to eq(true)
      post :withdraw_admin, {id: @chair, request: ChairWimi.find_by(user: @wimi)}
      expect(User.find(@wimi.id).is_admin?(@chair)).to eq(false)
    end

    it 'withdraws admin rights of last admin' do
      login_with @admin
      post :withdraw_admin, {id: @chair, request: ChairWimi.find_by(user: @admin)}
      expect(User.find(@admin.id).is_admin?(@chair)).to eq(true)
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

    it 'creates a new Chair with admin and representative different' do
      user1 = FactoryGirl.create(:user)
      login_with @superadmin
      expect {
        post :create, { :chair => {:name => 'Test'}, :admin_user => @user, :representative_user => user1}
      }.to change(Chair, :count).by(1)
    end

    it 'creates a new Chair with one user as admin and representative' do
      login_with @superadmin
      expect {
        post :create, { :chair => {:name => 'Test'}, :admin_user => @user, :representative_user => @user}
      }.to change(Chair, :count).by(1)
    end

    it 'does not create chair with wrong parameters' do
      user1 = FactoryGirl.create(:user)
      login_with @superadmin
      chair_count = Chair.all.count
      post :create, { :chair => {:name => 'Test'}}
      expect(Chair.all.count).to eq(chair_count)
    end
  end

  describe 'POST #update' do
    before(:each) do
      @superadmin = FactoryGirl.create(:user)
      @superadmin.superadmin = true
      @user = FactoryGirl.create(:user)
    end

    it 'modifies an existing chair with same admin and representative' do
      login_with @superadmin
      expect(Chair.all.size).to eq(0)
      post :create, { :chair => {:name => 'Test'}, :admin_user => @user, :representative_user => @user}
      expect(Chair.all.size).to eq(1)
      expect(Chair.last.name).to eq('Test')
      expect(Chair.last.admins.select{ |admin| (admin.user.id == @user.id) }.size).to eq(1)
      expect(Chair.last.representative.user.id).to eq(@user.id)
      put :update, :id => Chair.last.id, :chair => {:name => 'NewTest'}, :admin_user => @superadmin, :representative_user => @superadmin
      expect(Chair.all.size).to eq(1)
      expect(Chair.last.name).to eq('NewTest')
      expect(Chair.last.admins.select{ |admin| (admin.user.id == @user.id) }.size).to eq(0)
      expect(Chair.last.representative.user.id).to_not eq(@user.id)
      expect(Chair.last.admins.select{ |admin| (admin.user.id == @superadmin.id) }.size).to eq(1)
      expect(Chair.last.representative.user.id).to eq(@superadmin.id)
    end

    it 'modifies an existing chair with different admin and representative' do
      login_with @superadmin
      expect(Chair.all.size).to eq(0)
      post :create, { :chair => {:name => 'Test'}, :admin_user => @user, :representative_user => @superadmin}
      expect(Chair.all.size).to eq(1)
      expect(Chair.last.name).to eq('Test')
      expect(Chair.last.admins.select{ |admin| (admin.user.id == @user.id) }.size).to eq(1)
      expect(Chair.last.representative.user.id).to eq(@superadmin.id)
      put :update, :id => Chair.last.id, :chair => {:name => 'NewTest'}, :admin_user => @superadmin, :representative_user => @user
      expect(Chair.all.size).to eq(1)
      expect(Chair.last.name).to eq('NewTest')
      expect(Chair.last.admins.select{ |admin| (admin.user.id == @user.id) }.size).to eq(0)
      expect(Chair.last.representative.user.id).to_not eq(@superadmin.id)
      expect(Chair.last.admins.select{ |admin| (admin.user.id == @superadmin.id) }.size).to eq(1)
      expect(Chair.last.representative.user.id).to eq(@user.id)
    end

    it 'does not modify a chair with wrong parameters' do
      login_with @superadmin
      expect(Chair.all.size).to eq(0)
      post :create, { :chair => {:name => 'Test'}, :admin_user => @user, :representative_user => @superadmin}
      expect(Chair.all.size).to eq(1)
      expect(Chair.last.name).to eq('Test')
      expect(Chair.last.admins.select{ |admin| (admin.user.id == @user.id) }.size).to eq(1)
      expect(Chair.last.representative.user.id).to eq(@superadmin.id)

      put :update, :id => Chair.last.id, :chair => {:name => 'NewTest'}, :admin_user => nil, :representative_user => nil
      expect(Chair.all.size).to eq(1)
      expect(Chair.last.name).to eq('Test')
      expect(Chair.last.admins.select{ |admin| (admin.user.id == @user.id) }.size).to eq(1)
      expect(Chair.last.representative.user.id).to eq(@superadmin.id)
    end
  end

  describe 'POST #destroy' do
    before(:each) do
      @superadmin = FactoryGirl.create(:user)
      @superadmin.superadmin = true
      @chair = FactoryGirl.create(:chair)
      @user = FactoryGirl.create(:user)
    end

    it 'destroys an existing chair' do
      login_with @superadmin
      expect {
        delete :destroy, { id: @chair.id }
      }.to change(Chair, :count).by(-1)
    end
  end

end