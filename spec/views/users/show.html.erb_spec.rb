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

  it 'expects Handed in time sheets section for wimis' do
    @user.update(superadmin: true)
    @chair = FactoryGirl.create(:chair)
    ChairWimi.create(user: @user, chair: @chair, representative: true)
    login_as(@user, scope: :user)
    visit user_path(@user)
    expect(page).to have_content(t('users.show.handed_in_timesheets'))
  end

  it 'expects time sheets overview section for wimis' do
    @user.update(superadmin: true)
    @chair = FactoryGirl.create(:chair)
    ChairWimi.create(user: @user, chair: @chair, representative: true)
    login_as(@user, scope: :user)
    visit user_path(@user)
    expect(page).to have_content(t('users.show.time_sheets_overview'))
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

  it 'does not allow the superadmin to see the profiles of other users' do
    superadmin = FactoryGirl.create(:user, superadmin: true)
    login_as(superadmin, scope: :user)

    visit user_path(@user)
    expect(current_path).to eq(dashboard_path)
  end

end
