require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'GET and POST' do
    it 'should create an entry in UserEvent table' do
      user = FactoryGirl.create(:user)
      another_user = FactoryGirl.create(:user)
      event = FactoryGirl.create(:event)
      login_with user
      expect(UserEvent.all.size).to eq(0)
      post :hide, {id: event.id}
      expect(UserEvent.all.size).to eq(1)
      post :hide, {id: event.id}
      expect(UserEvent.all.size).to eq(1)
      login_with another_user
      expect {
        post :hide, {id: event.id}
      }.to change(UserEvent, :count).by(1)
    end

    it 'should test the redirection to holiday path' do
      chair = FactoryGirl.create(:chair)
      representative = FactoryGirl.create(:user)
      user = FactoryGirl.create(:user)
      ChairWimi.create(chair: chair, user: representative, representative: true, application: 'accepted')
      ChairWimi.create(chair: chair, user: user, application: 'accepted')
      holiday = FactoryGirl.create(:holiday, user: user)

      post :show_request, {status: 'holiday', request_id: holiday.id}
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(holiday)
    end

    it 'should test the redirection to trip path' do
      chair = FactoryGirl.create(:chair)
      representative = FactoryGirl.create(:user)
      user = FactoryGirl.create(:user)
      ChairWimi.create(chair: chair, user: representative, representative: true, application: 'accepted')
      ChairWimi.create(chair: chair, user: user, application: 'accepted')
      trip = FactoryGirl.create(:trip, user: user)

      post :show_request, {status: 'trip', request_id: trip.id}
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(trip)
    end

    it 'should test the redirection to trip path' do
      chair = FactoryGirl.create(:chair)
      representative = FactoryGirl.create(:user)
      user = FactoryGirl.create(:user)
      ChairWimi.create(chair: chair, user: representative, representative: true, application: 'accepted')
      ChairWimi.create(chair: chair, user: user, application: 'accepted')
      expense = FactoryGirl.create(:expense, user: user)

      post :show_request, {status: 'expense', request: expense}
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(expense)
    end

    it 'tests the redirection to dashboard if request does not exist' do
      post :show_request, {status: 'xyz', request_id: 132812}
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(dashboard_path)
    end
  end
end
