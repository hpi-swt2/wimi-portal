require 'rails_helper'

describe 'adding work days to a project' do
  before :each do
    @user = FactoryGirl.create(:user)
    FactoryGirl.create(:contract, hiwi: @user)
    @project = FactoryGirl.create(:project, title: 'AddWorkingHours')
    @project.users << @user
    login_as @user
  end

  it 'is possible from a project\'s index page' do
    visit project_path(@project)
    click_on I18n.t('projects.show.add_working_hours')
    expect(current_path).to eq(new_work_day_path)
  end

  it 'is possible from the dashboard' do
    visit dashboard_path
    click_on I18n.t('dashboard.actions.enter_work_hours', project_name: @project.title)
    expect(current_path).to eq(new_work_day_path)
  end

end
