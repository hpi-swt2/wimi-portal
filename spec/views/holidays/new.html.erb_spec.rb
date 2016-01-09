require 'rails_helper'

RSpec.describe 'holidays/new', type: :view do
  before(:each) do
    assign(:holiday, Holiday.new)
  end

  it 'renders new holiday form' do
    render

    assert_select 'form[action=?][method=?]', holidays_path, 'post' do
    end
  end

  it 'only shows users that are wimi at the chair as replacement' do
  	chair = FactoryGirl.create(:chair)
  	chair2 = FactoryGirl.create(:chair)
    user1 = FactoryGirl.create(:user, division_id: 1)
  	user2 = FactoryGirl.create(:user, division_id: 1)
  	user3 = FactoryGirl.create(:user, division_id: 1)
  	user4 = FactoryGirl.create(:user, division_id: 2)
  	chair1wimi = FactoryGirl.create(:chair_wimi, user_id: user2.id, chair_id: chair.id, admin: true)
  	chair2wimi = FactoryGirl.create(:chair_wimi, user_id: user4.id, chair_id: chair2.id, admin: true)
  	sign_in user1

  	render
  	find(:html, "checkbox").set(true)
  	assert_select 'div>div', text: 'John Doe'.to_s, count: 1
  end
end
