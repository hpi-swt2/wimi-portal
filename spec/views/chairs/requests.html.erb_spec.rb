require 'rails_helper'

RSpec.describe 'chairs/requests.html.erb', type: :view do
  before :each do
    @user = FactoryGirl.create(:user)
    @chair = FactoryGirl.create(:chair)
    holiday = FactoryGirl.create(:holiday, user_id: @user.id, status: 1)
    @allrequests = assign(:allrequests, [{name: holiday.user.name, type: 'Holiday Request',
                                          handed_in: holiday.created_at, status: holiday.status, action: holiday_path(holiday)}])
    @statuses = ['applied']
    @types = ['holidays']

  end

  it 'shows all requests for a chair' do
    render
    expect(rendered).to have_content(@user.name)
  end
end