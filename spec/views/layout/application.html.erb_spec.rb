require 'rails_helper'

RSpec.describe 'navigation bar', type: :view do

  shared_examples 'a registered User' do
    it 'should link to home' do
      expect(page).to have_link('Wimi Portal', href: current_url)
    end

    it 'should link to profile' do
      expect(page).to have_link('Profile', href: user_path(@user))
    end

    it 'should link to logout' do
      expect(page).to have_link('Logout', href: destroy_user_session_path)
    end

    it 'should have a select to change the language' do
      select('Deutsch', from: 'languageSelect')
      page.execute_script("$('#languageSelect').trigger('change')")
      expect(@user).to have_attributes(language: 'de')
    end
  end

  context 'for a registered User' do
    it_behaves_like 'a registered User'
    before(:each) do
      @user = FactoryGirl.create(:user)
      login_as @user
      visit root_path
    end

    it 'should link to projects' do
      expect(page).to have_link('Projects', href: projects_path)
    end

    it 'should show 4 links' do
      expect(page).to have_css('nav a', count: 4)
    end
  end

  context 'for a superadmin' do
    it_behaves_like 'a registered User'
    before(:each) do
      @user = FactoryGirl.create(:user, superadmin: true)
      login_as @user
      visit root_path
    end

    it 'should show 3 links' do
      expect(page).to have_css('nav a', count: 3)
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
      expect(page).to have_link('Projects', href: projects_path)
    end

    it 'should show 4 links' do
      expect(page).to have_css('nav a', count: 4)
    end
  end

  context 'for a hiwi' do
    it_behaves_like 'a registered User'
    before(:each) do
      @user = FactoryGirl.create(:user)
      chair = FactoryGirl.create(:chair)
      project = FactoryGirl.create(:project, chair: chair, status: true)
      @user.projects << project
      login_as @user
      visit root_path
    end

    it 'should link to projects' do
      expect(page).to have_link('Projects', href: projects_path)
    end

    it 'should show 4 links' do
      expect(page).to have_css('nav a', count: 4)
    end
  end

  context 'for a chair representative' do
    it_behaves_like 'a registered User'
    before(:each) do
      chair = FactoryGirl.create(:chair)
      @user = FactoryGirl.create(:user)
      FactoryGirl.create(:chair_representative, user: @user, chair: chair)
      login_as @user
      visit root_path
    end

    it 'should link to projects' do
      expect(page).to have_link('Projects', href: projects_path)
    end

    it 'should link to chairs' do
      expect(page).to have_link('Research Groups', href: chairs_path)
    end

    it 'should show 5 links' do
      expect(page).to have_css('nav a', count: 5)
    end
  end

  context 'for an admin' do
    it_behaves_like 'a registered User'
    before(:each) do
      chair = FactoryGirl.create(:chair)
      @user = FactoryGirl.create(:user)
      FactoryGirl.create(:chair_wimi, user: @user, chair: chair, admin: true)
      login_as @user
      visit root_path
    end

    it 'should link to projects' do
      expect(page).to have_link('Projects', href: projects_path)
    end

    it 'should link to chairs' do
      expect(page).to have_link('Research Groups', href: chairs_path)
    end

    it 'should show 5 links' do
      expect(page).to have_css('nav a', count: 5)
    end
  end
end