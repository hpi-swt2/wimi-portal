require 'rails_helper'

RSpec.describe 'projects/show', type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @chair = FactoryGirl.create(:chair)
    @wimi = FactoryGirl.create(:chair_representative, user: FactoryGirl.create(:user), chair: @chair).user

    login_as @user
    @project = FactoryGirl.create(:project, chair_id: @wimi.chair.id)
    allow(view).to receive(:current_user).and_return(@user)
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Factory Project/)
  end

  it 'has information about the project on page as a chair representative' do
    representative = FactoryGirl.create(:chair_representative, user: @user, chair: @chair).user
    login_as representative
    project = FactoryGirl.create(:project, chair: representative.chair, status: true)
    representative.projects << project
    visit project_path(project)

    expect(page).to have_content(project.title)
    expect(page).to have_content(project.chair.name)
    expect(page).to have_content(project.chair.representative.user.name)
    expect(page).to have_content(I18n.t('projects.show.public'))
    expect(page).to have_content(representative.name)
  end

  context 'as hiwi' do
    before(:each) do
      chair_representative = FactoryGirl.create(:chair_representative, user: @user, chair: @chair).user
      @hiwi = FactoryGirl.create(:user)

      login_as @hiwi
      @project = FactoryGirl.create(:project, chair: chair_representative.chair, status: true)
      visit project_path(@project)
    end

    it 'has information about the project on page' do
      expect(page).to have_content(@project.title)
      expect(page).to have_content(@project.chair.name)
      expect(page).to have_content(@project.chair.representative.user.name)
      expect(page).to have_content(I18n.t('projects.show.public'))
      expect(page).to have_content(@hiwi.name)
    end

    it 'shows leave project button if part of project' do
      @hiwi.projects << @project
      visit current_path
      expect(page).to have_content('Leave Project')
    end

    it 'shows no leave project button if not part of project' do
      expect(page).to_not have_content('Leave Project')
    end

    it 'shows add working hours button' do
      @hiwi.projects << @project
      visit current_path
      expect(page).to have_link('Add working hours')
    end

    it 'shows no add working hours button if not part of project' do
      expect(page).to_not have_link('Add working hours')
    end

    it 'shows working hours' do
      @hiwi.projects << @project
      visit current_path
      expect(page).to have_content('Working hours')
    end
  end

  context 'as wimi' do
    before(:each) do
      representative = FactoryGirl.create(:chair_representative, user: @user, chair: @chair).user
      @wimi_user = FactoryGirl.create(:user)
      @wimi = FactoryGirl.create(:wimi, user: @wimi_user, chair: @chair).user

      login_as @wimi
      @project = FactoryGirl.create(:project, chair: @wimi.chair, status: true)
      visit project_path(@project)
    end

    it 'has information about the project on page' do
      expect(page).to have_content(@project.title)
      expect(page).to have_content(@project.chair.name)
      expect(page).to have_content(@project.chair.representative.user.name)
      expect(page).to have_content(I18n.t('projects.show.public'))
      expect(page).to have_content(@wimi.name)
    end

    it 'shows leave project button if part of project' do
      @wimi.projects << @project
      visit current_path
      expect(page).to have_content('Leave Project')
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
      expect(page).to have_selector(:link_or_button, I18n.t('projects.form.show_working_hours'))
    end

    it 'shows one button to inspect all working hour report for this project' do
      user = FactoryGirl.create(:user)
      @wimi.projects << @project
      user.projects << @project
      visit current_path
      expect(page).to have_content(I18n.t('projects.form.show_all_working_hours'), count: 1)
      expect(page).to have_selector(:link_or_button, I18n.t('projects.form.show_all_working_hours'))
    end
  end
end
