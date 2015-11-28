require 'spec_helper'
require 'rails_helper'

describe 'Applying to a project' do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @wimi = FactoryGirl.create(:wimi)
    @project = @wimi.projects.first

    login_as(@user)
    visit project_path(@project)
    click_on(I18n.t('helpers.links.apply'))

    @project_application = ProjectApplication.last()
  end

  it 'should create a project application' do
    expect(current_path).to eq(project_applications_path)

    visit project_path(@project)

    expect(@project_application.user).to eq(@user)
    expect(page).to have_text I18n.t('helpers.links.pending_cancel')
    expect(@user.user?)
    expect(@project_application.pending?)
  end

  it 'should be acceptable' do
    login_as(@wimi)
    visit project_path(@project)
    click_on(I18n.t('helpers.links.accept_application'))

    expect(@user.wimi?)
    expect(@project_application.accepted?)
  end

  it 'should be declinable and reapplyable' do
    login_as(@wimi)
    visit project_path(@project)
    click_on(I18n.t('helpers.links.decline_application'))

    expect(@project_application.declined?)
    expect(current_path).to eq(project_path(@project))

    login_as(@user)
    visit project_path(@project)
    click_on(I18n.t('helpers.links.refused_reapply'))

    expect(@project_application.pending?)
  end
end