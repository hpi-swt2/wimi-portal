require 'rails_helper'

describe 'user login' do
	context 'when user requests a page and is not logged in' do
		before :each do
			@user = FactoryGirl.create(:user, username: 'user', password: 'pw')
			@chair = FactoryGirl.create(:chair)
		end
		it 'they are redirected after successfully logging in with external sign in' do
			visit chair_path(@chair)
			click_on I18n.t('helpers.application_tabs.external_sign_in')
			fill_in 'Username', with: 'user'
			fill_in 'Password', with: 'pw'
			click_on I18n.t('users.external_login.login')
			expect(page).to have_current_path(chair_path(@chair))
		end
	end
end