require 'rails_helper'

describe 'user login' do
	context 'when user requests a page and is not logged in' do
		before :each do
			@user = FactoryGirl.create(:user, username: 'username', password: 'pw')
			@chair = FactoryGirl.create(:chair)
		end
		it 'they are redirected after successfully logging in with external sign in' do
			visit chair_path(@chair)
			find(:linkhref, external_login_path).click
			# ids of inputs
			fill_in 'user_username', with: @user.username
			fill_in 'user_password', with: @user.password
			find('#main-content').find(:submit).click
			expect(page).to_not have_danger_flash_message
			expect(page).to have_current_path(chair_path(@chair))
		end
	end
end