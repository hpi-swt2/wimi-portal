require 'rails_helper'

RSpec.describe 'projects/edit', type: :view do
  before(:each) do
    @chair = FactoryGirl.create(:chair)
    @representative = FactoryGirl.create(:user)
    FactoryGirl.create(:wimi, user: @representative, chair: @chair, representative: true)
    @wimi = FactoryGirl.create(:user)
    FactoryGirl.create(:wimi, user: @wimi, chair: @chair)
    @wimi2 = FactoryGirl.create(:user)
    FactoryGirl.create(:wimi, user: @wimi2, chair: @chair)
  end

  it 'can be edited by a wimi' do
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, status: true)
    @wimi.projects << project
    visit project_path(project)
    expect(page).to have_link(nil, edit_project_path(project))
    click_on I18n.t('helpers.links.edit_short')
    new_project_title = 'My New Project'
    fill_in 'project_title', with: new_project_title
    click_on I18n.t('helpers.submit.update', model: project.model_name.human)
    project.reload
    expect(project.title).to eq(new_project_title)
  end

  it 'can be deleted by a wimi' do
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, status: true)
    project_title = project.title
    @wimi.projects << project
    visit edit_project_path(project)
    expect(page).to have_delete_link(project)
    find('a[data-method="delete"]').click
    expect(page).to have_content(I18n.t 'projects.destroy.success')
    expect(page).to have_no_content(project_title)
  end

  it 'can be set inactive by a wimi' do
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, status: true)
    @wimi.projects << project
    visit edit_project_path(project)
    expect(page).to have_selector(:link_or_button, I18n.t('projects.show.set_inactive'))
    click_on I18n.t('projects.show.set_inactive')
    project.reload
    expect(project.status).to be false
  end

  it 'can be set active by a wimi' do
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, status: false)
    @wimi.projects << project
    visit edit_project_path(project)
    expect(page).to have_selector(:link_or_button, I18n.t('projects.show.set_active'))
    click_on I18n.t('projects.show.set_active')
    project.reload
    expect(project.status).to be true
  end

  it 'is possible for a wimi to sign himself out of the project' do
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair)
    @wimi.projects << project
    @wimi2.projects << project
    visit edit_project_path(project)
    find('a[id="SignOutMyself"]').click
    project.reload
    expect(current_path).to eq(projects_path)
    expect(project.users).not_to include(@wimi)
  end

  it 'is not possible for a wimi to sign himself out of the project when he is the last one' do
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair)
    @wimi.projects << project
    @wimi2.projects << project
    visit edit_project_path(project)
    expect(page).not_to have_link('id="SignOutMyself"')
  end

  it 'is possible for a wimi to sign a hiwi out of the project' do
    user = FactoryGirl.create(:user)
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair)
    @wimi.projects << project
    user.projects << project
    visit edit_project_path(project)
    find('a[id="SignOut"]').click
    project.reload
    expect(current_path).to eq(edit_project_path(project))
    expect(project.users).not_to include(user)
  end

  it 'denies the superadmin to edit a project' do
    superadmin = FactoryGirl.create(:user, superadmin: true)
    project = FactoryGirl.create(:project)
    login_as superadmin
    visit edit_project_path(project)
    expect(current_path).to eq(dashboard_path)
  end
end
