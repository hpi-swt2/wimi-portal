require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  before(:each) do
    @user = assign(:user, FactoryGirl.create(:user))
    login_as(@user, scope: :user)
  end

  it 'shows the profile page' do
    visit user_path(@user)
    expect(page).to have_content(I18n.t('users.show.title'))
  end

  it 'shows the correct chair in profile' do
    chair = FactoryGirl.create(:chair)
    ChairWimi.create(user: @user, chair: chair, application: 'accepted')
    visit user_path(@user)
    expect(page).to have_content(chair.name)
  end
end
