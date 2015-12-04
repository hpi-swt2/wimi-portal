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
  end

  it 'should create a project application' do
    expect(current_path).to eq(project_applications_path)

    visit project_path(@project)

    project_application =  @user.project_applications.find_by(project_id: @project.id)
    expect(project_application.user).to eq(@user)
    expect(page).to have_text I18n.t('helpers.links.pending_cancel')

    expect(project_application.status).to eq('pending')
  end

  it 'should be acceptable' do
    login_as(@wimi)
    visit project_path(@project)
    click_on(I18n.t('helpers.links.accept_application'))

    project_application =  @user.project_applications.find_by(project_id: @project.id)
    expect(User.find(@user.id).role).to eq('hiwi')
    expect(project_application.status).to eq('accepted')
  end

  it 'should be declinable and reapplyable' do
    login_as(@wimi)
    visit project_path(@project)
    click_on(I18n.t('helpers.links.decline_application'))

    project_application =  @user.project_applications.find_by(project_id: @project.id)
    expect(project_application.status).to eq('declined')
    expect(current_path).to eq(project_path(@project))

    login_as(@user)
    visit project_path(@project)
    click_on(I18n.t('helpers.links.refused_reapply'))

    project_application =  @user.project_applications.find_by(project_id: @project.id)
    expect(project_application.status).to eq('pending')
  end

  it 'can be cancelled' do
    visit project_path(@project)
    click_on(I18n.t('helpers.links.pending_cancel'))

    expect(@user.project_applications.find_by(project_id: @project.id)).to eq(nil)
  end
end