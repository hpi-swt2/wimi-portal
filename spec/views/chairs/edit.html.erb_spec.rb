require 'rails_helper'

RSpec.describe 'chairs/edit.html.erb', type: :view do
  before :each do
    @superadmin = FactoryGirl.create(:user, superadmin: true, first_name: 'Super', last_name: 'Admin')
    @user = FactoryGirl.create(:user)
  end

  it 'does not expect the superadmin in list of possible chair admins or representatives' do
    login_as(@superadmin, scope: :user)
    chair = FactoryGirl.create(:chair)
    visit edit_chair_path(chair)

    expect(page).to have_content(@user.name)
    expect(page).to_not have_content(@superadmin.name)
  end
end
