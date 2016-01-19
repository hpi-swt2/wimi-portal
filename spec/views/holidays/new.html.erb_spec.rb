require 'rails_helper'

RSpec.describe 'holidays/new', type: :view do
  before(:each) do
    assign(:holiday, Holiday.new)
    user = FactoryGirl.create(:user)
    @chair = FactoryGirl.create(:chair)
    ChairWimi.first.update_attributes(user_id: user.id)
    login_as user
  end

  it 'only shows users that are wimi at the chair as replacement' do
    chair2 = FactoryGirl.create(:chair)
    user2 = FactoryGirl.create(:user, chair: @chair, first_name: 'name1')
    user3 = FactoryGirl.create(:user, chair: @chair, first_name: 'name2')
    user4 = FactoryGirl.create(:user, chair: chair2, first_name: 'name3')
    user2.chair_wimi.update(admin: true, chair_id: @chair.id)
    user4.chair_wimi.update(admin: true, chair_id: chair2.id)

    visit new_holiday_path

    expect(page).to have_select 'holiday_replacement_user_id', with_options: [user2.name]
    expect(page).not_to have_select 'holiday_replacement_user_id', with_options: [user3.name]
    expect(page).not_to have_select 'holiday_replacement_user_id', with_options: [user4.name]
  end
end