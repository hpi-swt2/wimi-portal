require 'rails_helper'

RSpec.describe 'holidays/edit', type: :view do
  before(:each) do
  	user = FactoryGirl.create(:user)
    @holiday = assign(:holiday, Holiday.create!(user_id: user.id))
  end

  it 'renders the edit holiday form' do
    render

    assert_select 'form[action=?][method=?]', holiday_path(@holiday), 'post' do
    end
  end
end
