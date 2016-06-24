require 'rails_helper'

RSpec.describe 'holidays/edit', type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @holiday = assign(:holiday, FactoryGirl.create(:holiday, user: @user))
    sign_in @user
  end

  it 'renders the edit holiday form' do
    render

    assert_select 'form[action=?][method=?]', holiday_path(@holiday), 'post' do
    end
  end

  it 'denies the superadmin to edit holidays' do
    superadmin = FactoryGirl.create(:user, superadmin: true)
    login_as superadmin
    visit edit_holiday_path(@holiday)
    expect(current_path).to eq(dashboard_path)
  end
end
