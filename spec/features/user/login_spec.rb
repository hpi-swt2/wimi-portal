require 'rails_helper'

feature 'Login' do
  before :each do
    @routes = [projects_path, dashboard_path, chairs_path, contracts_path] #'/holidays', '/trips'
  end

  it 'should not show any page as long as you are not logged in' do
    @routes.each do |route|
      visit route
      expect(page).to have_current_path(new_user_session_path)
    end
  end
  
  context 'via username/password' do
    before :each do
      @user = FactoryBot.create(:user, username: 'wimi-admin', password: 'wimi-admin-password')
      visit external_login_path
    end
    
    it 'should login a user with their credentials' do
      fill_in 'user_username', with: @user.username
      fill_in 'user_password', with: @user.password
      find('#main-content').find(:submit).click

      expect(page).to_not have_danger_flash_message
      @routes.each do |route|
        visit route
        expect(page).to have_link_href destroy_user_session_path
      end
    end
      
    it 'should not login a user with wrong credentials' do
      fill_in 'user_username', with: @user.username
      fill_in 'user_password', with: @user.password + '_wrong'
      find('#main-content').find(:submit).click
      expect(page).to have_danger_flash_message
      expect(page).to have_current_path(external_login_path)
    end
  end
end

