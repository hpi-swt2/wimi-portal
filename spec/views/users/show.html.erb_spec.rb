require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  it 'shows the correct chair in profile' do
    chair = FactoryGirl.create(:chair)
    ChairWimi.create(user_id: @user.id, chair_id: chair.id, application: 'accepted')
    login_as(@user, scope: :user)
    visit user_path(@user)
    expect(page).to have_content(chair.name)
  end
end
