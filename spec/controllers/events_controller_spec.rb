require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  before(:each) do
  end

  describe 'hide event' do
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
  end
end