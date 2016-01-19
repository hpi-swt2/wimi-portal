require 'rails_helper'

describe 'login via OpenID' do
  before :each do
    @routes = ['/projects', '/holidays', '/trips', '/travel_expense_reports']
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
