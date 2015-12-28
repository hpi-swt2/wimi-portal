require 'rails_helper'


RSpec.describe RequestsController, type: :controller do

  describe 'GET #requests' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @chair = FactoryGirl.create(:chair)
      @representative = FactoryGirl.create(:user)
      ChairWimi.create(user_id: @representative.id, chair_id: @chair.id, representative: true)
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

    it 'show all requests of chair' do
      FactoryGirl.create(:holiday, user_id: @representative.id, status: 1)
      FactoryGirl.create(:trip, user_id: @representative.id, status: 1)
      FactoryGirl.create(:expense, user_id: @representative.id, status: 1)
      FactoryGirl.create(:holiday, user_id: @user.id, status: 1)
      sign_in @representative
      get :requests, {id: @chair}
      expect(response).to render_template('requests')
    end

    it 'shows filtered requests' do
      sign_in @representative
      post :requests_filtered, {id: @chair}
      expect(response).to have_http_status(:success)
    end
  end
end