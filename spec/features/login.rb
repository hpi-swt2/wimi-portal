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

  it 'should not login without authentication' do
    page.driver.post('/users/sign_in?openid_url=tim.paul@student.hpi.uni-potsdam.de')
    expect(page).to have_content 'Logged in successfully'
  end

  it 'should be obligatory to insert a valid email' do
    @current_user = FactoryGirl.create(:user)
    login_as @current_user
    @current_user.update_attribute(:email, '')
    @routes.each do |route|
      visit route
      expect(page).to have_content 'Please set a valid email address first'
    end
  end
end