require 'spec_helper'
require 'rails_helper'

describe 'Applying to a project' do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project)
    @wimi = FactoryGirl.create(:wimi)

    login_as(@user)
    visit project_path(@project)
    click_on(I18n.t("helpers.links.apply"))

    @project_application = ProjectApplication.last()
  end

  it 'should create a project application' do
    expect(current_path).to eq(project_applications_path)

    visit project_path(@project)

    expect(@project_application.user).to eq(@user)
    expect(page).to have_text I18n.t("helpers.links.pending_cancel")
    expect(@project_application.status).to eq("pending")
  end

  it 'should be acceptable' do
    login_as(@wimi)
    # visit project_path(@project)
    click_on(I18n.t("helpers.links.accept"))

    expect(@project_application.status).to eq("accepted")
  end

  it 'should be declinable and reapplyable' do

    login_as(@wimi)
    # visit project_path(@project)
    click_on(I18n.t("helpers.links.decline"))

    expect(@project_application.status).to eq("declined")

    login_as(@user)
    click_on(I18n.t("helpers.links.refused_reapply"))

    expect(@project_application.status).to eq("pending")
  end
end