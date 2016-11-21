require 'rails_helper'

RSpec.describe ChairsController, type: :controller do
  before(:each) do
    @chair = FactoryGirl.create(:chair)
    @admin = FactoryGirl.create(:user, first_name: 'Admin')
    @wimi = FactoryGirl.create(:user, first_name: 'WiMi')
    @user = FactoryGirl.create(:user, first_name: 'User')
    @representative = @chair.representative.user
    @superadmin = FactoryGirl.create(:user, superadmin: true)
    FactoryGirl.create(:wimi, user: @wimi, chair: @chair, application: 'accepted')
    FactoryGirl.create(:wimi, user: @admin, chair: @chair, admin: true, application: 'accepted')
  end
  
  describe 'GET #index' do
    it 'shows index of all chairs' do
      # If there is only a single chair, there is a redirect to the show page
      FactoryGirl.create(:chair, description: 'A different chair')
      login_with @user
      get :index

      expect(response).to have_http_status(:success)
    end
  end
  
  describe 'GET #show' do
    it 'returns http success as admin' do
      login_with @admin
      get :show, {id: @chair}

      expect(response).to have_http_status(:success)
    end
    it 'returns http success as any user' do
      login_with @user
      get :show, {id: @chair}

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    it 'edits the chair for superadmins' do
      login_with @superadmin

      get :edit, {id: @chair}

      expect(response).to have_http_status(:success)
    end

    it 'edits the chair for the chair admin' do
      login_with @admin
      get :edit, {id: @chair}

      expect(response).to have_http_status(:success)
    end

    it 'does not edit the chair for another admin' do
      user = FactoryGirl.create(:user)
      chair2 = FactoryGirl.create(:chair)
      chair_wimi = FactoryGirl.create(:wimi, admin: true, user: user, chair: chair2)

      login_with user
      get :edit, {id: @chair}

      expect(response).to_not have_http_status(:success)
    end
  end

  describe 'GET #new' do
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
    it 'creates a new Chair with admin and representative different' do
      user1 = FactoryGirl.create(:user)

      login_with @superadmin

      expect {
        post :create, {chair: {name: 'Test'}, admins: {user: @user}, representative: user1}
      }.to change(Chair, :count).by(1)
    end

    it 'creates a new Chair with one user as admin and representative' do
      login_with @superadmin

      expect {
        post :create, {chair: {name: 'Test'}, admins: {user: @user}, representative: @user}
      }.to change(Chair, :count).by(1)
    end

    it 'does create a chair without admins and without representative' do
      login_with @superadmin

      chair_count = Chair.all.count
      post :create, {chair: {name: 'Test'}}

      expect(Chair.all.count).to eq(chair_count + 1)
    end

    it 'does not create chair with superadmin as admin or representative' do
      login_with @superadmin

      chair_count = Chair.all.count
      post :create, {chair: {name: 'Test'}, admins: {user: @superadmin}, representative: @superadmin}

      expect(Chair.all.count).to eq(chair_count)
    end
  end

  describe 'POST #update' do
    before(:each) do
      @user2 = FactoryGirl.create(:user)
    end

    it 'modifies an existing chair with same admin and representative' do
      login_with @superadmin

      put :update, id: @chair.id, chair: {name: 'NewTest'}, admins: {user: @user2}, representative: @user2
      @chair.reload

      expect(@chair.name).to eq('NewTest')
      expect(@chair.admins.count { |admin| (admin.user == @admin) }).to eq(0)
      expect(@chair.representative.user).to_not eq(@representative)
      expect(@chair.admins.count { |admin| (admin.user == @user2) }).to eq(1)
      expect(@chair.representative.user).to eq(@user2)
    end

    it 'modifies an existing chair with different admin and representative' do
      login_with @superadmin
      
      expect(Chair.all.size).to eq(1)

      put :update, id: @chair.id, chair: {name: 'NewTest'}, admins: {user: @user2}, representative: @user
      @chair.reload
      
      expect(Chair.all.size).to eq(1)
      expect(@chair.name).to eq('NewTest')
      expect(@chair.admins.count{ |admin| (admin.user == @user) }).to eq(0)
      expect(@chair.representative.user).to_not eq(@user2)
      expect(@chair.admins.count{ |admin| (admin.user == @user2) }).to eq(1)
      expect(@chair.representative.user).to eq(@user)
    end

    it 'does not modify a chair with wrong parameters' do
      login_with @superadmin

      expect(Chair.all.size).to eq(1)
      old_name = @chair.name
      
      put :update, id: @chair.id, chair: {name: 'NewTest'}, admins: {user: 9_999_999}
      @chair.reload
      
      expect(Chair.all.size).to eq(1)
      expect(@chair.name).to eq(old_name)
      expect(@chair.admins.count { |admin| (admin.user == @admin) }).to eq(1)
      expect(@chair.representative.user).to eq(@representative)
    end
  end

  describe 'POST #destroy' do
    it 'destroys an existing chair' do
      login_with @superadmin

      expect {
        delete :destroy, {id: @chair.id}
      }.to change(Chair, :count).by(-1)
    end

    it 'destroys the projects of the chair' do
      project = FactoryGirl.create(:project, chair_id: @chair.id)
      delete :destroy, {id: @chair.id}
      expect project == nil
    end
  end

  describe 'GET #requests' do
    it 'does not show requests for users' do
      sign_in @user
      get :requests, {id: @chair}

      expect(response).to have_http_status(302)
    end

    it 'shows request page for chairs representative' do
      sign_in @representative
      get :requests, {id: @chair}

      expect(response).to have_http_status(:success)
    end

    it 'does not show request page for another chair' do
      chair1 = FactoryGirl.create(:chair)
      sign_in @representative
      get :requests, {id: chair1}

      expect(response).to have_http_status(302)
    end

    it 'shows all requests of chair' do
      FactoryGirl.create(:holiday, user: @representative, status: 1)
      FactoryGirl.create(:trip, user: @representative, status: 1)
      FactoryGirl.create(:expense, user: @representative, status: 1)
      FactoryGirl.create(:holiday, user: @user, status: 1)

      sign_in @representative
      get :requests, {id: @chair}

      expect(response).to render_template('requests')
    end

    it 'shows some filtered requests of chair' do
      FactoryGirl.create(:holiday, user_id: @representative.id, status: 1)
      FactoryGirl.create(:trip, user_id: @representative.id, status: 1)
      FactoryGirl.create(:expense, user_id: @representative.id, status: 1)
      FactoryGirl.create(:holiday, user_id: @user.id, status: 1)

      sign_in @representative
      get :requests_filtered, {id: @chair, holiday: true, applied: true}

      expect(response).to render_template('requests')
    end

    describe 'tests error' do
      before(:each) do
        @superadmin = FactoryGirl.create(:user, superadmin: true)
      end

      let(:invalid_attributes) {
        {id: @chair, name: ''}
      }
      let(:valid_session) { {} }

      it 'if chair could not be created' do
        sign_in @superadmin
        post :create, {chair: invalid_attributes}, valid_session

        expect(response).to render_template('new')
      end
    end
  end
  
  describe 'POST' do

    it 'removes wimi from chair' do
      login_with @admin
      post :remove_from_chair, {id: @chair, request: @wimi.chair_wimi}

      expect(@wimi.reload.is_wimi?).to eq(false)
    end

    it 'tries to remove admin' do
      login_with @admin
      post :remove_from_chair, {id: @chair, request: @admin.chair_wimi}

      expect(@wimi.reload.is_wimi?).to eq(true)
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
end
