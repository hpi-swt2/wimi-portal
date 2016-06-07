require 'rails_helper'

RSpec.describe 'projects/show', type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @chair = FactoryGirl.create(:chair)
    @project = FactoryGirl.create(:project, chair: @chair)

    login_as @user
    allow(view).to receive(:current_user).and_return(@user)
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Factory Project/)
  end

  it 'has information about the project on page as a chair representative' do
    representative = @chair.representative.user
    login_as representative
    project = FactoryGirl.create(:project, chair: @chair, status: true)
    representative.projects << project
    visit project_path(project)

    expect(page).to have_content(project.title)
    expect(page).to have_content(project.chair.name)
    expect(page).to_not have_content('public')
    
    # only because rep is also wimi of the project
    expect(page).to have_content(project.chair.representative.user.name)
  end

  context 'as hiwi' do
    before(:each) do
      @hiwi = @user
      login_as @hiwi
      @hiwi.projects << @project
      
      visit project_path(@project)
    end

    it 'has information about the project on page' do
      expect(page).to have_content(@project.title)
      expect(page).to have_content(@project.chair.name)
      expect(page).to_not have_content(@project.chair.representative.user.name)
      expect(page).to_not have_content('public')
    end

    it 'shows leave project button if part of project' do
      visit current_path
      expect(page).to have_content('Leave')
    end

    # hiwi can't see project if not a member
#    it 'shows no leave project button if not part of project' do
#      expect(page).to_not have_content('Leave Project')
#    end

    it 'shows add working hours button' do
      @hiwi.projects << @project
      visit current_path
      expect(page).to have_link('Add working hours')
    end

    # hiwi can't see project if not a member
#    it 'shows no add working hours button if not part of project' do
#      expect(page).to_not have_link('Add working hours')
#    end

    it 'shows working hours' do
      @hiwi.projects << @project
      visit current_path
      expect(page).to have_content('Working hours')
    end
    
    it 'is possible for a hiwi to sign himself out of the project' do
      visit project_path @project
      click_link 'Leave Project'
      @project.reload
      
      expect(@project.users).not_to include(@hiwi)
    end
  end

  context 'as wimi' do
    before(:each) do
      representative = @chair.representative.user
      @wimi = FactoryGirl.create(:wimi, user: FactoryGirl.create(:user), chair: @chair).user
      @wimi2 = FactoryGirl.create(:wimi, user: FactoryGirl.create(:user), chair: @chair).user
      @project = FactoryGirl.create(:project, chair: @chair, status: true)

      login_as @wimi
      visit project_path(@project)
    end

    it 'has information about the project on page' do
      expect(page).to have_content(@project.title)
      expect(page).to have_content(@project.chair.name)
      expect(page).to have_content(l(@project.created_at))
      expect(page).to_not have_content(@project.chair.representative.user.name)
      expect(page).to_not have_content('public')
    end

    it 'shows leave project button if part of project' do
      @wimi.projects << @project
      @wimi2.projects << @project
      visit current_path
      expect(page).to have_content('Leave Project')
    end

    it 'does not show leave project button if he is the only wimi' do
      @wimi.projects << @project
      visit current_path
      expect(page).not_to have_content('Leave Project')
    end

    it 'shows no leave project button if not part of project' do
      expect(page).to_not have_content('Leave Project')
    end

    it 'shows no add working hours button' do
      @wimi.projects << @project
      visit current_path
      expect(page).to_not have_link('Add working hours')
    end

    it 'shows a button to inspect a user specific working hour report for this project' do
      user = FactoryGirl.create(:user)
      @wimi.projects << @project
      user.projects << @project
      visit current_path
      expect(page).to have_selector(:link_or_button, 'Show working hours')
    end

    it 'shows one button to inspect all working hour report for this project' do
      user = FactoryGirl.create(:user)
      @wimi.projects << @project
      user.projects << @project
      visit current_path
      expect(page).to have_content(I18n.t('projects.form.show_all_working_hours'), count: 1)
      expect(page).to have_selector(:link_or_button, 'Show all working hours')
    end
    
    it 'not possible for wimi to edit if not a member' do
      visit current_path
      expect(page).not_to have_selector(:link_or_button, I18n.t('helpers.links.edit'))
      expect(page).not_to have_selector(:link_or_button, I18n.t('helpers.links.destroy'))
      expect(page).not_to have_selector(:link_or_button, I18n.t('projects.show.set_inactive'))
#      expect(page).to have_selector(:link_or_button, I18n.t('helpers.links.back'))
    end
  end
end
