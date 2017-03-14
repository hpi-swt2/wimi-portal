require "rails_helper"

describe 'updating event preferences' do 
	before :each do
		@user = FactoryGirl.create(:user)
		login_as @user
	end

	it 'should save checked fields' do
		visit edit_user_path(@user)

		find(:css, "#user_event_settings_1").set(true)
		
		click_on('Save')

		@user.reload
		expect(@user.event_settings).to eq([1])
	end

	it 'should persist, boxes should automatically get reselected' do
		@user.update_event_settings([1,2])

		visit edit_user_path(@user)

		expect(find(:css, "#user_event_settings_1")).to be_checked
		expect(find(:css, "#user_event_settings_2")).to be_checked
	end
end