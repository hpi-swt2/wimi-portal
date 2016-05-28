require 'rails_helper'

feature 'Login' do
  before :each do
    @routes = ['/projects']#, '/holidays', '/trips'
  end

  it 'should not show any page as long as you are not logged in' do
    @routes.each do |route|
      visit route
      expect(page).to have_content 'Please login first'
    end
  end

  context 'via OpenID' do
    it 'should be obligatory to insert a valid email before visiting all sites' do
      @current_user = FactoryGirl.create(:user)
      login_as @current_user
      @current_user.update_attribute(:email, 'invalid_email')
      @routes.each do |route|
        visit route
        expect(page).to have_content 'Please set a valid email address first'
      end

      fill_in 'user_email', with: 'valid@e.mail'
      click_on 'Save'

      @routes.each do |route|
        visit route
        expect(page).to_not have_content 'Please set a valid email address first'
        expect(page).to have_content 'Logout'
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

      expect(page).to_not have_content 'Please sign in'
      @routes.each do |route|
        visit route
        expect(page).to have_content 'Logout'
      end
    end
    
    context 'with wrong credentials' do
      
      it 'should not login a user' do
        fill_in 'user_username', with: @user.username
        fill_in 'user_password', with: @user.password + '_wrong'
        click_on I18n.t('users.external_login.login')

        @routes.each do |route|
          visit route
          expect(page).to_not have_content 'Logout'
        end
      end
      
      it 'should redirect to login page', exclude: true do
        fill_in 'user_username', with: @user.username
        fill_in 'user_password', with: @user.password + '_wrong'
        click_on I18n.t('users.external_login.login')
        
        expect(current_path).to eq(external_login_path)
      end
    end
  end
end

