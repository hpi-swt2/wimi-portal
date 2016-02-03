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

  it 'deletes every activity that is older than the last 50' do
    chair = FactoryGirl.create(:chair)
    project = FactoryGirl.create(:project, chair: chair)
    user = FactoryGirl.create(:hiwi)
    time_sheet = FactoryGirl.create(:time_sheet, user_id: user.id, project_id: project.id)

    wimi = User.find(FactoryGirl.create(:wimi, chair: chair).user_id)
    wimi.projects = []
    wimi.projects << project
    project.users << wimi

    expect(wimi.is_wimi?).to be true

    60.times do |_i|
      ActiveSupport::Notifications.instrument('event', {trigger: time_sheet.id, target: wimi.id, seclevel: :wimi, type: 'EventTimeSheetAccepted'})
    end

    expect(Event.all.size).to eq(60)

    login_with(wimi)
    get :index

    expect(Event.all.size).to eq(50)
  end
end
