require 'rails_helper'

describe 'actions from dashboard' do
  before :each do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project)
    FactoryGirl.create(:contract, hiwi: @user)
    @project.users << @user
    login_as @user
    visit dashboard_path
  end

  it 'should be possible to add working hours for a project from the dashboard' do
    click_link(I18n.t('dashboard.actions.enter_work_hours', project_name: @project.title))
    expect(current_path).to eq(time_sheets_path)
    expect(page).to have_content(@project.title)
  end

end
