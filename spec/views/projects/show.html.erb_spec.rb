require 'rails_helper'

RSpec.describe 'projects/show', type: :view do
  before(:each) do
    @chair = FactoryGirl.create(:chair)
    @user = FactoryGirl.create(:user)
  end

  it 'has information about the project on page as a chair representative' do
    representative = FactoryGirl.create(:chair_representative, user_id: @user.id, chair_id: @chair.id).user
    login_as representative
    project = FactoryGirl.create(:project, chair: representative.chair, status: true)
    representative.projects << project
    visit project_path(project.id)

    expect(page).to have_content(project.title)
    expect(page).to have_content(project.chair.name)
    expect(page).to have_content(project.chair.representative.user.name)
    expect(page).to have_content(I18n.t('projects.show.public'))
    expect(page).to have_content(I18n.t('projects.show.project_leader'))
    expect(page).to have_content(representative.name)
  end

  it 'has information about the project on page as a wimi' do
    representative = FactoryGirl.create(:chair_representative, user_id: @user.id, chair_id: @chair.id).user
    @wimi_user = FactoryGirl.create(:user)
    wimi = FactoryGirl.create(:wimi, user_id: @wimi_user.id, chair_id: @chair.id).user

    login_as wimi
    project = FactoryGirl.create(:project, chair: wimi.chair, status: true)
    wimi.projects << project
    visit project_path(project.id)

    expect(page).to have_content(project.title)
    expect(page).to have_content(project.chair.name)
    expect(page).to have_content(project.chair.representative.user.name)
    expect(page).to have_content(I18n.t('projects.show.public'))
    expect(page).to have_content(I18n.t('projects.show.project_leader'))
    expect(page).to have_content(wimi.name)
  end

  it 'has information about the project on page as a hiwi' do
    chair_representative = FactoryGirl.create(:chair_representative, user_id: @user.id, chair_id: @chair.id).user
    hiwi = FactoryGirl.create(:user)

    login_as hiwi
    project = FactoryGirl.create(:project, chair: chair_representative.chair, status: true)
    hiwi.projects << project
    visit project_path(project.id)

    expect(page).to have_content(project.title)
    expect(page).to have_content(project.chair.name)
    expect(page).to have_content(project.chair.representative.user.name)
    expect(page).to have_content(I18n.t('projects.show.public'))
    expect(page).to have_content(I18n.t('projects.show.project_leader'))
    expect(page).to have_content(hiwi.name)
  end

  it 'shows a button for a wimi to inspect a user specific working hour report for this project' do
    @representative = FactoryGirl.create(:chair_representative, user_id: @user.id, chair_id: @chair.id).user
    @wimi_user = FactoryGirl.create(:user)
    @wimi = FactoryGirl.create(:wimi, user_id: @wimi_user.id, chair_id: @chair.id).user
    user = FactoryGirl.create(:user)
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, public: false)
    @wimi.projects << project
    user.projects << project
    visit project_path(project)
    expect(page).to have_selector(:link_or_button, I18n.t('projects.form.show_working_hours'))
  end

  it 'shows a button for a wimi to inspect all working hour report for this project' do
    @representative = FactoryGirl.create(:chair_representative, user_id: @user.id, chair_id: @chair.id).user
    @wimi_user = FactoryGirl.create(:user)
    @wimi = FactoryGirl.create(:wimi, user_id: @wimi_user.id, chair_id: @chair.id).user
    user = FactoryGirl.create(:user)
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, public: false)
    @wimi.projects << project
    user.projects << project
    visit project_path(project)
    expect(page).to have_selector(:link_or_button, I18n.t('projects.form.show_all_working_hours'))
  end
end
