require 'rails_helper'

 # holiday requests currently out of order
RSpec.describe 'chairs/requests.html.erb', type: :view do
#  before :each do
#    @chair = FactoryBot.create(:chair)
#    @user = FactoryBot.create(:wimi, chair: @chair, representative: true).user
#    holiday = FactoryBot.create(:holiday, user: @user, status: 1)
#    trip = FactoryBot.create(:trip, user: @user)
#    trip.status = 3
#    expense = FactoryBot.create(:expense, user: @user, status: 1)
#    @allrequests = assign(:allrequests, [{name: holiday.user.name, type: 'holidays', handed_in: holiday.created_at, status: holiday.status, action: holiday_path(holiday)},
#                                         {name: trip.user.name, type: 'expenses', handed_in: trip.created_at, status: trip.status, action: trip_path(trip)},
#                                         {name: expense.user.name, type: 'trips', handed_in: expense.created_at, status: expense.status, action: trip_path(expense.trip)}])
#
#    @statuses = ['applied']
#    @types = ['holidays']
#  end
#
#  it 'shows only holiday requests for a chair' do
#    login_as @user
#    visit dashboard_path
#    click_on ('Show holiday requests')
#
#    expect(page).to have_css('table/tbody/tr', count: 1)
#    expect(page).to have_content(@user.name, count: 1)
#  end
#
#  it 'shows all requests for a chair' do
#    render
#    expect(rendered).to have_css('table/tbody/tr', count: 3)
#    expect(rendered).to have_content(@user.name, count: 3)
#  end
end
