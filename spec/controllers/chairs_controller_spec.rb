require 'rails_helper'

RSpec.describe ChairsController, type: :controller do
  describe 'GET #index' do
    before(:each) do
      @chair = FactoryGirl.create(:chair)
      @admin = FactoryGirl.create(:user)
      FactoryGirl.create(:chair_wimi, user: @admin, chair: @chair, admin: true, application: 'accepted')
      @wimi = FactoryGirl.create(:user)
      FactoryGirl.create(:chair_wimi, user: @wimi, chair: @chair, application: 'accepted')
      @user = FactoryGirl.create(:user)
      @superadmin = FactoryGirl.create(:user, superadmin: true)
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
      expect(response).to redirect_to(dashboard_path)

      login_with(@wimi)
      get :show, {id: @chair}
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(dashboard_path)

      login_with(@superadmin)
      get :show, {id: @chair}
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(dashboard_path)
    end

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

  describe 'GET #edit' do
    before(:each) do
      @chair = FactoryGirl.create(:chair)
    end

    it 'edits the chair for superadmins' do
      login_with(FactoryGirl.create(:user, superadmin: true))
      get :edit, {id: @chair.to_param}
      expect(response).to have_http_status(:success)
    end

    it 'edits the chair for the chair admin' do
      user = FactoryGirl.create(:user)
      chair_wimi = FactoryGirl.create(:chair_wimi, admin: true, user: user, chair: @chair)
      login_with(user)
      get :edit, {id: @chair.to_param}
      expect(response).to have_http_status(302)
    end

    it 'does not edit the chair for another admin' do
      user = FactoryGirl.create(:user)
      chair2 = FactoryGirl.create(:chair)
      chair_wimi = FactoryGirl.create(:chair_wimi, admin: true, user: user, chair: chair2)
      login_with(user)
      get :edit, {id: @chair.to_param}
      expect(response).to_not have_http_status(:success)
    end
  end

  describe 'POST #apply' do
    before :each do
      @chair = FactoryGirl.create(:chair)
      @user = FactoryGirl.create(:user)
    end

    it 'applies for a chair' do
      login_with @user
      expect {
        post :apply, {chair: @chair}
      }.to change(ChairWimi, :count).by(1)
      expect(ChairWimi.find_by(user: @user, chair: @chair).application).to eq 'pending'
    end

    it 'creates only one new chair application' do
      login_with @user
      expect {
        post :apply, {chair: @chair}
      }.to change(ChairWimi, :count).by(1)

      expect {
        post :apply, {chair: @chair}
      }.to change(ChairWimi, :count).by(0)
    end
  end

  describe 'POST #accept_request' do
    it 'accepts a hiwi' do
      chair = FactoryGirl.create(:chair)
      user = FactoryGirl.create(:user)
      pending_wimi = FactoryGirl.create(:chair_wimi, user: user, chair: chair, application: 'pending')
      admin = FactoryGirl.create(:user)
      FactoryGirl.create(:chair_wimi, user: admin, chair: chair, admin: true, application: 'accepted')

      login_with admin
      old_wimi_amount = chair.wimis.count
      post :accept_request, {id: chair, request: pending_wimi}
      pending_wimi.reload
      expect(pending_wimi.application).to eq 'accepted'
      chair.reload
      expect(chair.wimis.count).to eq(old_wimi_amount + 1)
    end
  end

  describe 'GET #new' do
    before(:each) do
      @superadmin = FactoryGirl.create(:user, superadmin: true)
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
      @superadmin = FactoryGirl.create(:user, superadmin: true)
      @user = FactoryGirl.create(:user)
    end

    it 'creates a new Chair with admin and representative different' do
      user1 = FactoryGirl.create(:user)
      login_with @superadmin
      expect {
        post :create, {chair: {name: 'Test'}, admin_user: @user, representative_user: user1}
      }.to change(Chair, :count).by(1)
    end

    it 'creates a new Chair with one user as admin and representative' do
      login_with @superadmin
      expect {
        post :create, {chair: {name: 'Test'}, admin_user: @user, representative_user: @user}
      }.to change(Chair, :count).by(1)
    end

    it 'does not create chair with wrong parameters' do
      login_with @superadmin
      chair_count = Chair.all.count
      post :create, {chair: {name: 'Test'}}
      expect(Chair.all.count).to eq(chair_count)
    end

    it 'does not create chair with superadmin as admin or representative' do
      login_with @superadmin
      chair_count = Chair.all.count
      post :create, {chair: {name: 'Test'}, admin_user: @superadmin, representative_user: @superadmin}
      expect(Chair.all.count).to eq(chair_count)
    end
  end

  describe 'POST #update' do
    before(:each) do
      @superadmin = FactoryGirl.create(:user, superadmin: true)
      @user = FactoryGirl.create(:user)
      @anotheruser = FactoryGirl.create(:user)
    end

    it 'modifies an existing chair with same admin and representative' do
      login_with @superadmin
      expect(Chair.all.size).to eq(0)
      post :create, {chair: {name: 'Test'}, admin_user: @user, representative_user: @user}
      expect(Chair.all.size).to eq(1)
      expect(Chair.last.name).to eq('Test')
      expect(Chair.last.admins.count { |admin| (admin.user == @user) }).to eq(1)
      expect(Chair.last.representative.user).to eq(@user)
      put :update, id: Chair.last.id, chair: {name: 'NewTest'}, admin_user: @anotheruser, representative_user: @anotheruser
      expect(Chair.all.size).to eq(1)
      expect(Chair.last.name).to eq('NewTest')
      expect(Chair.last.admins.count { |admin| (admin.user == @user) }).to eq(0)
      expect(Chair.last.representative.user).to_not eq(@user)
      expect(Chair.last.admins.count { |admin| (admin.user == @anotheruser) }).to eq(1)
      expect(Chair.last.representative.user).to eq(@anotheruser)
    end

    it 'modifies an existing chair with different admin and representative' do
      login_with @superadmin
      expect(Chair.all.size).to eq(0)
      post :create, {chair: {name: 'Test'}, admin_user: @user, representative_user: @anotheruser}
      expect(Chair.all.size).to eq(1)
      expect(Chair.last.name).to eq('Test')
      expect(Chair.last.admins.count { |admin| (admin.user == @user) }).to eq(1)
      expect(Chair.last.representative.user).to eq(@anotheruser)
      put :update, id: Chair.last.id, chair: {name: 'NewTest'}, admin_user: @anotheruser, representative_user: @user
      expect(Chair.all.size).to eq(1)
      expect(Chair.last.name).to eq('NewTest')
      expect(Chair.last.admins.count{ |admin| (admin.user == @user) }).to eq(0)
      expect(Chair.last.representative.user).to_not eq(@anotheruser)
      expect(Chair.last.admins.count{ |admin| (admin.user == @anotheruser) }).to eq(1)
      expect(Chair.last.representative.user).to eq(@user)
    end

    it 'does not modify a chair with wrong parameters' do
      login_with @superadmin
      expect(Chair.all.size).to eq(0)
      post :create, {chair: {name: 'Test'}, admin_user: @user, representative_user: @anotheruser}
      expect(Chair.all.size).to eq(1)
      expect(Chair.last.name).to eq('Test')
      expect(Chair.last.admins.count { |admin| (admin.user == @user) }).to eq(1)
      expect(Chair.last.representative.user).to eq(@anotheruser)

      put :update, id: Chair.last.id, chair: {name: 'NewTest'}, admin_user: nil, representative_user: nil
      expect(Chair.all.size).to eq(1)
      expect(Chair.last.name).to eq('Test')
      expect(Chair.last.admins.count { |admin| (admin.user == @user) }).to eq(1)
      expect(Chair.last.representative.user).to eq(@anotheruser)
    end
  end

  describe 'POST #destroy' do
    before(:each) do
      @superadmin = FactoryGirl.create(:user, superadmin: true)
      @chair = FactoryGirl.create(:chair)
    end

    it 'destroys an existing chair' do
      login_with @superadmin
      expect {
        delete :destroy, {id: @chair.id}
      }.to change(Chair, :count).by(-1)
    end
  end

  describe 'GET #requests' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @chair = FactoryGirl.create(:chair)
      @representative = FactoryGirl.create(:user)
      ChairWimi.create(user: @representative, chair: @chair, representative: true)
    end

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
      FactoryGirl.create(:travel_expense_report, user: @representative, status: 1)
      FactoryGirl.create(:holiday, user: @user, status: 1)
      sign_in @representative
      get :requests, {id: @chair}
      expect(response).to render_template('requests')
    end

    it 'shows some filtered requests of chair' do
      FactoryGirl.create(:holiday, user_id: @representative.id, status: 1)
      FactoryGirl.create(:trip, user_id: @representative.id, status: 1)
      FactoryGirl.create(:travel_expense_report, user_id: @representative.id, status: 1)
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
end
