require 'rails_helper'

feature 'Login' do
  before :each do
    @routes = [projects_path, time_sheets_path, chairs_path, contracts_path] #'/holidays', '/trips'
  end

  it 'should not show any page as long as you are not logged in' do
    @routes.each do |route|
      visit route
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_danger_flash_message
    end
  end

  context 'via OpenID' do
    it 'should be obligatory to insert a valid email before visiting all sites' do
      current_user = FactoryGirl.create(:user)
      login_as current_user
      current_user.update_attribute(:email, 'invalid_email')
      @routes.each do |route|
        visit route
        expect(page).to have_danger_flash_message
        expect(page).to have_content 'Please set a valid email address first'
      end
    end
  end
  
  context 'via username/password' do
    before :each do
      @user = FactoryGirl.create(:user, username: 'wimi-admin', password: 'wimi-admin-password')
      visit external_login_path
    end
    
    it 'should login a user with their credentials' do
      fill_in 'user_username', with: @user.username
      fill_in 'user_password', with: @user.password
      click_on I18n.t('users.external_login.login')

      expect(page).to_not have_danger_flash_message
      @routes.each do |route|
        visit route
        expect(page).to have_content I18n.t('helpers.application_tabs.logout')
      end
    end
      
    it 'should not login a user with wrong credentials' do
      pending "skipped until double display of flash message is fixed in devise views"

      fill_in 'user_username', with: @user.username
      fill_in 'user_password', with: @user.password + '_wrong'
      click_on I18n.t('users.external_login.login')
      expect(page).to have_danger_flash_message
      expect(page).to have_current_path(external_login_path)
    end
  end
end

