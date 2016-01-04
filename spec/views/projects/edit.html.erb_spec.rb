require 'rails_helper'

RSpec.describe 'projects/edit', type: :view do
  before(:each) do
    @chair = FactoryGirl.create(:chair)
    @user = FactoryGirl.create(:user)
    @representative = FactoryGirl.create(:chair_representative, user_id:@user.id, chair_id: @chair.id).user
    @wimi_user = FactoryGirl.create(:user)
    @wimi = FactoryGirl.create(:wimi, user_id: @wimi_user.id, chair_id: @chair.id).user
  end

  it 'can be edited by a wimi' do
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, status: true)
    @wimi.projects << project
    visit projects_path
    expect(page).to have_selector(:link_or_button, 'Edit')
    click_on 'Edit'
    fill_in 'project_title', with: 'My New Project'
    click_on 'Update Project'
    project.reload
    expect(project.title).to eq('My New Project')
  end

  it 'can be deleted by a wimi' do
    login_as @wimi
    project = FactoryGirl.create(:project, chair: @wimi.chair, status: true)
    projectTitle = project.title
    @wimi.projects << project
    visit projects_path
    expect(page).to have_selector(:link_or_button, 'Delete')
    click_on 'Delete'
    expect(page).to have_content('Project was successfully destroyed.')
    expect(page).to have_no_content(projectTitle)
  end
end
