require 'rails_helper'

RSpec.describe 'navigation bar', type: :view do
  shared_examples 'a registered User' do
    it 'should link to home' do
      within('div.navbar-collapse') do
        expect(page).to have_link(nil, href: root_path)
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
      @user = FactoryBot.create(:user, superadmin: true)
      login_as @user
      visit root_path
    end
  end

  context 'for a wimi' do
    it_behaves_like 'a registered User'
    before(:each) do
      chair = FactoryBot.create(:chair)
      wimi_user = FactoryBot.create(:user)
      @user = FactoryBot.create(:wimi, user: wimi_user, chair: chair).user
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
      @user = FactoryBot.create(:user)
      chair = FactoryBot.create(:chair)
      @project = FactoryBot.create(:project, chair: chair, status: true)
      @project2 = FactoryBot.create(:project, chair: chair, status: true)
      @user.projects << @project
      login_as @user
      visit root_path
    end

    it 'should link to a project#show page if the user is part of only one project' do
      click_on I18n.t('activerecord.models.project.one').titleize
      expect(current_path).to eq(project_path(@project))
    end

    it 'should link to project#index if the user is part of multiple projects' do
      @user.projects << @project2
      visit root_path
      expect(page).to have_link(I18n.t('activerecord.models.project.other').titleize, href: projects_path)
    end

    it 'should link to the dashboard' do
      expect(page).to have_link(nil, href: dashboard_path)
    end
  end

  context 'for a chair representative' do
    it_behaves_like 'a registered User'
    before(:each) do
      chair = FactoryBot.create(:chair)
      @user = FactoryBot.create(:user)
      FactoryBot.create(:wimi, user: @user, chair: chair, representative: true)
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
      chair = FactoryBot.create(:chair)
      @user = FactoryBot.create(:user)
      FactoryBot.create(:wimi, user: @user, chair: chair, admin: true)
      login_as @user
      visit root_path
    end

    it 'should link to projects' do
      expect(page).to have_link(I18n.t('activerecord.models.project.other').titleize, href: projects_path)
    end
  end
end
