require 'rails_helper'


RSpec.describe RequestsController, type: :controller do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @chair = FactoryGirl.create(:chair)
    sign_in @user
  end

  it 'does not show requests for users' do
    get :requests, { id: @chair}
    expect(response).to have_http_status(302)
  end
end