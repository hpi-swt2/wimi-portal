require 'rails_helper'

RSpec.describe 'navigation bar', type: :view do
  shared_examples 'a registered User' do
    it 'should link to home' do
      within('div.navbar-collapse') do
        expect(page).to have_link(nil, root_path)
      end
    end

    it 'should link to profile' do
      within('div.navbar-collapse') do
        expect(page).to have_link(nil, href: user_path(@user))
      end
    end

    it 'should link to logout' do
      within('div.navbar-collapse') do
        expect(page).to have_link(I18n.t('helpers.application_tabs.logout').titleize, href: destroy_user_session_path)
      end
    end

    #     Test for the language select, doesn't work at the moment. When javascript tests are fully funtional, it may work.
    #    it 'should have a select to change the language', js: true do
    #      select('Deutsch', from: 'languageSelect')
    #      page.execute_script("$('#languageSelect').trigger('change')")
    #      expect(@user).to have_attributes(language: 'de')
    #    end
  end

  context 'for a superadmin' do
    it_behaves_like 'a registered User'
    before(:each) do
      @user = FactoryGirl.create(:user, superadmin: true)
      login_as @user
      visit root_path
    end
  end

  context 'for a wimi' do
    it_behaves_like 'a registered User'
    before(:each) do
      chair = FactoryGirl.create(:chair)
      wimi_user = FactoryGirl.create(:user)
      @user = FactoryGirl.create(:wimi, user: wimi_user, chair: chair).user
      login_as @user
      visit root_path
    end

    it 'should link to projects' do
      expect(page).to have_link(I18n.t('activerecord.models.project.other').titleize, href: projects_path)
    end
  end

  context 'for a hiwi' do
    it_behaves_like 'a registered User'
    before(:each) do
      @user = FactoryGirl.create(:user)
      chair = FactoryGirl.create(:chair)
      @project = FactoryGirl.create(:project, chair: chair, status: true)
      @project2 = FactoryGirl.create(:project, chair: chair, status: true)
      @user.projects << @project
      login_as @user
      visit root_path
    end

    it 'should link to a project#show page if the user is part of only one project' do
      expect(page).to have_link(I18n.t('activerecord.models.project.one').titleize, href: project_path(@project))
    end

    it 'should link to project#index if the user is part of multiple projects' do
      @user.projects << @project2
      visit root_path
      expect(page).to have_link(I18n.t('activerecord.models.project.other').titleize, href: projects_path)
    end

    it 'should link to the overview of time sheets' do
      expect(page).to have_link(I18n.t('activerecord.models.time_sheet.other').titleize, href: time_sheets_path)
    end
  end

  context 'for a chair representative' do
    it_behaves_like 'a registered User'
    before(:each) do
      chair = FactoryGirl.create(:chair)
      @user = FactoryGirl.create(:user)
      FactoryGirl.create(:wimi, user: @user, chair: chair, representative: true)
      login_as @user
      visit root_path
    end

    it 'should link to projects' do
      expect(page).to have_link(I18n.t('activerecord.models.project.other').titleize, href: projects_path)
    end
  end

  context 'for an admin' do
    it_behaves_like 'a registered User'
    before(:each) do
      chair = FactoryGirl.create(:chair)
      @user = FactoryGirl.create(:user)
      FactoryGirl.create(:wimi, user: @user, chair: chair, admin: true)
      login_as @user
      visit root_path
    end

    it 'should link to projects' do
      expect(page).to have_link(I18n.t('activerecord.models.project.other').titleize, href: projects_path)
    end
  end
end
