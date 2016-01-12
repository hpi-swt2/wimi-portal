require 'rails_helper'

RSpec.describe 'holidays/new', type: :view do
  before(:each) do
    assign(:holiday, Holiday.new)
    user = FactoryGirl.create(:user, division_id: 1)
    login_as user
  end

  it 'only shows users that are wimi at the chair as replacement' do
  	chair = FactoryGirl.create(:chair)
  	chair2 = FactoryGirl.create(:chair)
  	user2 = FactoryGirl.create(:user, division_id: 1, first_name: 'name1')
  	user3 = FactoryGirl.create(:user, division_id: 1, first_name: 'name2')
  	user4 = FactoryGirl.create(:user, division_id: 2, first_name: 'name3')
  	chair1wimi = FactoryGirl.create(:chair_wimi, user_id: user2.id, chair_id: chair.id, admin: true)
  	chair2wimi = FactoryGirl.create(:chair_wimi, user_id: user4.id, chair_id: chair2.id, admin: true)

  	visit new_holiday_path

  	expect(page).to have_select 'holiday_replacement_user_id', with_options: [user2.name]
  	expect(page).not_to have_select 'holiday_replacement_user_id', with_options: [user3.name]
  	expect(page).not_to have_select 'holiday_replacement_user_id', with_options: [user4.name]
  end
end
