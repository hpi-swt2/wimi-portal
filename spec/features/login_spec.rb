require 'rails_helper'

describe 'login via OpenID' do
  before :each do
    @routes = ['/publications', '/projects', '/holidays', '/trips', '/expenses']
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

    fill_in 'user_email', with: 'valid email'
    click_on 'Update User'

    @routes.each do |route|
      visit route
      expect(page).to_not have_content 'Please set a valid email address first'
    end
  end
end

describe 'login via email/password' do
  before :each do
    visit '/'
    expect(page).to have_content 'Please login first'
  end

  it 'should login the superadmin with his credentials' do
    superadmin = FactoryGirl.create(:user, superadmin: true, email: 'wimi-admin', password: 'wimi-admin-password')
    visit '/superadmin'

    fill_in 'user_email', with: superadmin.email
    fill_in 'user_password', with: superadmin.password
    click_on 'Log in'

    expect(page).to_not have_content 'Please login first'
    routes = ['/publications', '/projects', '/holidays', '/trips', '/expenses']
    routes.each do |route|
      visit route
      expect(page).to have_content 'Logout'
    end
  end

  it 'should not login the superadmin with wrong credentials' do
    superadmin = FactoryGirl.create(:user, superadmin: true, email: 'wimi-admin', password: 'wimi-admin-password')
    visit '/superadmin'

    fill_in 'user_email', with: superadmin.email
    fill_in 'user_password', with: 'wrong_password'
    click_on 'Log in'

    routes = ['/publications', '/projects', '/holidays', '/trips', '/expenses']
    routes.each do |route|
      visit route
      expect(page).to_not have_content 'Logout'
    end
  end

  it 'should not login a user' do
    user = FactoryGirl.create(:user, email: 'no-admin')
    visit '/superadmin'

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Please sign in'
    routes = ['/publications', '/projects', '/holidays', '/trips', '/expenses']
    routes.each do |route|
      visit route
      expect(page).to_not have_content 'Logout'
    end
  end
end
