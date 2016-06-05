require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  before(:each) do
    @user = assign(:user, FactoryGirl.create(:user))
    login_as(@user, scope: :user)
  end

  it 'shows the profile page' do
    visit user_path(@user)
    expect(page).to have_content(@user.name)
  end

  it 'expects handed in time sheets section for wimis' do
    # will be back soon
#    @wimi = assign(:user, FactoryGirl.create(:user))
#    @chair = FactoryGirl.create(:chair)
#    ChairWimi.create(user: @wimi, chair: @chair, application: 'accepted')
#    
#    login_as(@wimi, scope: :user)
#    visit user_path(@user)
#    
#    expect(page).to have_content(t('users.show.handed_in_timesheets'))
  end

  it 'expects time sheets overview section for wimis' do
    # will be back soon
#    @chair = FactoryGirl.create(:chair)
#    ChairWimi.create(user: @user, chair: @chair, application: 'accepted')
#    login_as(@user, scope: :user)
#    visit user_path(@user)
#    expect(page).to have_content(t('users.show.time_sheets_overview'))
  end

  it 'shows the correct chair in profile' do
    chair = FactoryGirl.create(:chair)
    ChairWimi.create(user: @user, chair: chair, application: 'accepted')
    visit user_path(@user)
    expect(page).to have_content(chair.name)
  end

  it 'allows the superadmin to see his own profile' do
    superadmin = FactoryGirl.create(:user, superadmin: true)
    login_as(superadmin, scope: :user)
    visit user_path(superadmin)
    expect(current_path).to eq(user_path(superadmin))
  end

#  it 'tests if a superadmin can only change his password in his user profile' do
#    superadmin = FactoryGirl.create(:user, superadmin: true)
#    login_as(superadmin, scope: :user)
#
#    visit user_path(superadmin)
#    expect(page).to_not have_content(t('users.show.signature'))
#    expect(page).to_not have_content(t('users.show.time_sheets_overview'))
#    expect(page).to_not have_content(t('users.show.handed_in_timesheets'))
#    expect(page).to_not have_content(t('users.show.holiday_requests'))
#    expect(page).to_not have_content(t('users.show.business_trips'))
#    expect(page).to_not have_content(t('users.show.user_data'))
#    expect(page).to have_content(t('users.show.password'))
#  end
end
