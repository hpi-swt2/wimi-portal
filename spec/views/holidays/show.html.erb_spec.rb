require 'rails_helper'

RSpec.describe 'holidays/show', type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @holiday = assign(:holiday, FactoryGirl.create(:holiday, user: @user))
    login_as @user
  end

  it 'changes the status to applied if request is filed' do
    chair = FactoryGirl.create(:chair)
    ChairWimi.first.update_attributes(user_id: @user.id)
    visit holiday_path(@holiday.id)
    click_on I18n.t('holidays.show.file')
    @holiday.reload
    expect(@holiday.status).to eq('applied')
  end

  it 'denys the superadmin see details of holidays' do
    superadmin = FactoryGirl.create(:user, superadmin: true)
    login_as superadmin
    visit holiday_path(@holiday)
    expect(current_path).to eq(root_path)
  end
end
