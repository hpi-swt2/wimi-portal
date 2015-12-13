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

    @project_application =  @user.project_applications.find_by(project_id: @project.id)
  end

  it 'should create a project application' do
    expect(current_path).to eq(project_applications_path)

    visit project_path(@project)

    expect(@project_application.user).to eq(@user)
    expect(page).to have_text I18n.t('helpers.links.pending_cancel')

    expect(@project_application.reload.status).to eq('pending')
  end

  it 'should be viewable on the project applications index' do
    visit projects_path
    expect(page).to have_text(@project.title)
  end

  it 'should be acceptable' do
    login_as(@wimi)
    visit project_path(@project)
    click_on(I18n.t('helpers.links.accept_application'))

    expect(@user.reload.is_hiwi?).to eq(true)
    expect(@project_application.reload.status).to eq('accepted')
  end

  it 'should be declinable and reapplyable' do
    login_as(@wimi)
    visit project_path(@project)
    click_on(I18n.t('helpers.links.decline_application'))

    expect(@project_application.reload.status).to eq('declined')
    expect(current_path).to eq(project_path(@project))

    login_as(@user)
    visit project_path(@project)
    click_on(I18n.t('helpers.links.refused_reapply'))

    expect(@project_application.reload.status).to eq('pending')
  end

  it 'can be cancelled' do
    visit project_path(@project)
    click_on(I18n.t('helpers.links.pending_cancel'))

    expect(@user.project_applications.find_by(project_id: @project.id)).to eq(nil)
  end
end