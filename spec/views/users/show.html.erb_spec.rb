require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  it 'expects Handed in time sheets section for wimis' do
    @user.update(superadmin: true)
    @chair = FactoryGirl.create(:chair)
    ChairWimi.create(user: @user, chair: @chair, representative: true)
    login_as(@user, scope: :user)
    visit user_path(@user)
    expect(page).to have_content(t('users.show.handed_in_timesheets'))
  end

  it 'shows the correct chair in profile' do
    chair = FactoryGirl.create(:chair)
    ChairWimi.create(user: @user, chair: chair, application: 'accepted')
    login_as(@user, scope: :user)
    visit user_path(@user)
    expect(page).to have_content(chair.name)
  end
end
