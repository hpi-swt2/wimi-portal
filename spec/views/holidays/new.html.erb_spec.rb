require 'rails_helper'

# currently out of order
RSpec.describe 'holidays/new', type: :view do
#  before(:each) do
#    assign(:holiday, Holiday.new)
#    user = FactoryBot.create(:user)
#    @chair = FactoryBot.create(:chair)
#    ChairWimi.first.update_attributes(user_id: user.id)
#    login_as user
#  end
#
#  it 'only shows users that are wimi at the chair as replacement' do
#    chair2 = FactoryBot.create(:chair)
#    user2 = FactoryBot.create(:user, chair: @chair, first_name: 'name1')
#    user3 = FactoryBot.create(:user, chair: @chair, first_name: 'name2')
#    user4 = FactoryBot.create(:user, chair: chair2, first_name: 'name3')
#    user2.chair_wimi.update(admin: true, chair: @chair)
#    user4.chair_wimi.update(admin: true, chair: chair2)
#
#    visit new_holiday_path
#
#    expect(page).to have_select 'replacement_selection', with_options: [user2.name]
#    expect(page).not_to have_select 'replacement_selection', with_options: [user3.name]
#    expect(page).not_to have_select 'replacement_selection', with_options: [user4.name]
#  end
#
#  it 'denies the superadmin to create new holidays' do
#    superadmin = FactoryBot.create(:user, superadmin: true)
#    login_as superadmin
#    visit new_holiday_path
#    expect(current_path).to eq(root_path)
#  end
end
