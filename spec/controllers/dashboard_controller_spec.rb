require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  it 'returns http success' do
    login_with create(:user)
    get :index
    expect(response).to have_http_status(:success)
  end

  it 'returns http redirect to login page' do
    get :index
    expect(response).to have_http_status(302)
  end

  it 'renders the Dashboard template' do
    login_with create(:user)
    get :index
    expect(response).to render_template('index')
  end
end