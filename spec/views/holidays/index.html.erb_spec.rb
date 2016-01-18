require 'rails_helper'

RSpec.describe 'holidays/index', type: :view do
  before(:each) do
    @user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    sign_in @user1
    assign(:holidays, [
      FactoryGirl.create(:holiday, user_id: @user1.id),
      FactoryGirl.create(:holiday, user_id: user2.id)
    ])
  end

  it 'renders a list of holidays if current user is wimi' do
    chair = FactoryGirl.create(:chair)
    ChairWimi.first.update_attributes(user_id: @user1.id)
    render
    assert_select 'tr>td', text: 'saved'.to_s, count: 1
  end
end
