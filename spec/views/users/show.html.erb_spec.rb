require 'rails_helper'	

RSpec.describe "users/show.html.erb", type: :view do
	it 'expects Handed in time sheets section for wimis' do
	 	@superadmin = FactoryGirl.create(:user)
	    @superadmin.superadmin = true
	    @chair = FactoryGirl.create(:chair)
    	ChairWimi.create(user: @superadmin, chair: @chair, representative: true)
    	login_as(@superadmin, scope: :user)
	    visit user_path(@superadmin)
    	expect(page).to have_content('Handed in time sheets:')
	end
end