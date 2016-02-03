require 'rails_helper'

describe 'login via OpenID' do
  before :each do
    @routes = ['/projects', '/holidays', '/trips']
  end

  it 'should not show any page as long as you are not logged in' do
    @routes.each do |route|
      visit route
      expect(page).to have_content 'Please login first'
    end
  end

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
    end
  end
end

describe 'login via username/password' do
  it 'should login the superadmin with his credentials' do
    visit '/'
    expect(page).to have_content 'Please login first'
    superadmin = FactoryGirl.create(:user, superadmin: true, username: 'wimi-admin', password: 'wimi-admin-password')
    visit superadmin_path

    fill_in 'user_username', with: superadmin.username
    fill_in 'user_password', with: superadmin.password
    click_on 'Log in'

    expect(page).to_not have_content 'Please sign in'
    routes = ['/holidays', '/trips']
    routes.each do |route|
      visit route
      expect(page).to have_content 'Logout'
    end
  end

  it 'should not login the superadmin with wrong credentials' do
    superadmin = FactoryGirl.create(:user, superadmin: true, username: 'wimi-admin', password: 'wimi-admin-password')
    visit '/superadmin'

    fill_in 'user_username', with: superadmin.username
    fill_in 'user_password', with: 'wrong_password'
    click_on 'Log in'

    routes = ['/holidays', '/trips']
    routes.each do |route|
      visit route
      expect(page).to_not have_content 'Logout'
    end
  end

  it 'should not login a user' do
    user = FactoryGirl.create(:user, username: 'no-admin')
    visit '/superadmin'

    fill_in 'user_username', with: user.username
    fill_in 'user_password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Please sign in'
    routes = ['/holidays', '/trips']
    routes.each do |route|
      visit route
      expect(page).to_not have_content 'Logout'
    end
  end

  it 'should not access the page if the user is already logged in' do
    superadmin = FactoryGirl.create(:user, superadmin: true, username: 'wimi-admin', password: 'wimi-admin-password')
    login_as superadmin
    visit superadmin_path
    expect(page).to have_content 'Log out first before accessing the superadmin login page.'
  end
end
