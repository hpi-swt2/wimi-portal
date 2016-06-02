require 'rails_helper'

feature 'Project information' do
  background do
    user = FactoryGirl.create(:user)
    chair = FactoryGirl.create(:chair)
    representative = FactoryGirl.create(:wimi, user: user, chair: chair, representative: true).user
    @current_user = FactoryGirl.create(:user, language: 'de')
    login_as @current_user
    @project = FactoryGirl.create(:project, chair: representative.chair)
    @project.users << @current_user
  end

  scenario 'Go on project site' do
    visit project_path(@project)
    expect(page).to have_content(@project.chair.name)
    # see view tests for more
  end
end
