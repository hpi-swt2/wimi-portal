require 'rails_helper'

RSpec.describe 'projects/edit', type: :view do
  before(:each) do
    @chair = FactoryGirl.create(:chair)
    @user = FactoryGirl.create(:user)
    @representative = FactoryGirl.create(:chair_representative, user: @user, chair: @chair).user
    @wimi_user = FactoryGirl.create(:user)
    @wimi = FactoryGirl.create(:wimi, user: @wimi_user, chair: @chair).user
  end

  it 'can be edited by a wimi' do
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, status: true)
    @wimi.projects << project
    visit project_path(project)
    expect(page).to have_selector(:link_or_button, I18n.t('helpers.links.edit'))
    click_on I18n.t('helpers.links.edit')
    fill_in 'project_title', with: 'My New Project'
    click_on I18n.t('projects.form.update_project')
    project.reload
    expect(project.title).to eq('My New Project')
  end

  it 'can be deleted by a wimi' do
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, status: true)
    project_title = project.title
    @wimi.projects << project
    visit project_path(project)
    expect(page).to have_selector(:link_or_button, I18n.t('helpers.links.destroy'))
    click_on 'Delete'
    expect(page).to have_content('Project was successfully destroyed.')
    expect(page).to have_no_content(project_title)
  end

  it 'can be set inactive by a wimi' do
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, status: true)
    @wimi.projects << project
    visit project_path(project)
    expect(page).to have_selector(:link_or_button, I18n.t('projects.show.set_inactive'))
    click_on I18n.t('projects.show.set_inactive')
    project.reload
    expect(project.status).to be false
  end

  it 'can be set active by a wimi' do
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, status: false)
    @wimi.projects << project
    visit project_path(project)
    expect(page).to have_selector(:link_or_button, I18n.t('projects.show.set_active'))
    click_on I18n.t('projects.show.set_active')
    project.reload
    expect(project.status).to be true
  end

  it 'can be set private by a wimi' do
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, public: true)
    @wimi.projects << project
    visit edit_project_path(project)
    find(:css, '#project_public_false').set(true)
    click_on I18n.t('projects.form.update_project')
    project.reload
    expect(project.public).to be false
  end

  it 'can be set public by a wimi' do
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, public: false)
    @wimi.projects << project
    visit edit_project_path(project)
    find(:css, '#project_public_true').set(true)
    click_on I18n.t('projects.form.update_project')
    project.reload
    expect(project.public).to be true
  end

  it 'is possible for a wimi to sign himself out of the project' do
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, public: false)
    @wimi.projects << project
    visit edit_project_path(project)
    find('a[id="SignOutMyself"]').click
    project.reload
    expect(current_path).to eq(project_path(project))
    expect(project.users).not_to include(@wimi)
  end

  it 'is possible for a hiwi to sign himself out of the project' do
    user = FactoryGirl.create(:user)
    login_as user
    project = FactoryGirl.create(:project, chair: @wimi.chair, public: false)
    user.projects << project
    visit project_path(project)
    click_on(I18n.t('projects.show.leave_project'))
    project.reload
    expect(current_path).to eq(project_path(project))
    expect(project.users).not_to include(user)
  end

  it 'is possible for a wimi to sign a hiwi out of the project' do
    user = FactoryGirl.create(:user)
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, public: false)
    @wimi.projects << project
    user.projects << project
    visit edit_project_path(project)
    find('a[id="SignOut"]').click
    project.reload
    expect(current_path).to eq(edit_project_path(project))
    expect(project.users).not_to include(user)
  end

  it 'not possible for wimi to edit or delete a project he just signed out' do
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, public: false)
    @wimi.projects << project
    visit edit_project_path(project)
    find('a[id="SignOutMyself"]').click
    project.reload
    expect(current_path).to eq(project_path(project))
    expect(page).not_to have_selector(:link_or_button, I18n.t('helpers.links.edit'))
    expect(page).not_to have_selector(:link_or_button, I18n.t('helpers.links.destroy'))
    expect(page).not_to have_selector(:link_or_button, I18n.t('projects.show.set_inactive'))
    expect(page).to have_selector(:link_or_button, I18n.t('helpers.links.back'))
  end
end
