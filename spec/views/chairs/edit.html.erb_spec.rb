require 'rails_helper'

RSpec.describe 'chairs/edit.html.erb', type: :view do
  before :each do
    @superadmin = FactoryBot.create(:user, superadmin: true, first_name: 'Super', last_name: 'Admin')
    @user = FactoryBot.create(:user)
    @chair = FactoryBot.create(:chair)
    login_as(@superadmin, scope: :user)
    visit edit_chair_path(@chair)
  end

  it 'expects buttons for superadmin' do
    expect(page).to have_delete_link(@chair)
  end

  it 'tests functionality of Destroy Button' do
    find('a[data-method="delete"]').click
    expect(page).to have_current_path(chairs_path)
    expect(page).to_not have_content(@chair.name)
  end

 # this is supposed to test the autocomplete feature.
 # TODO: change view to use UsersController#autocomplete and move test accordingly
#  it 'should not have the superadmin in list of possible chair admins or representatives' do
#    login_as(@superadmin, scope: :user)
#    chair = FactoryBot.create(:chair)
#    visit edit_chair_path(chair)
#
#    expect(page).to have_content(@user.name)
#    expect(page).to_not have_content(@superadmin.name)
#  end
end
