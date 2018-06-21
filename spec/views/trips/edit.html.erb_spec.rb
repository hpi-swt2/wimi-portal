require 'rails_helper'

# trips currently out of order
RSpec.describe 'trips/edit', type: :view do
#  before(:each) do
#    @user = FactoryBot.create(:user)
#    FactoryBot.create(:wimi, chair: FactoryBot.create(:chair), user: @user)
#    login_as @user
#    @trip = assign(:trip, FactoryBot.create(:trip, user: @user))
#  end
#
#  it 'renders the edit trip form' do
#    visit edit_trip_path(@trip)
#
#    render
#
#    assert_select 'form[action=?][method=?]', trip_path(@trip), 'post' do
#      assert_select 'input#trip_destination[name=?]', 'trip[destination]'
#
#      assert_select 'input#trip_reason[name=?]', 'trip[reason]'
#
#      assert_select 'textarea#trip_annotation[name=?]', 'trip[annotation]'
#
#      assert_select 'input#trip_signature[name=?]', 'trip[signature]'
#    end
#  end
#
#  it 'shows the trip detail page after editing' do
#    visit trip_path(@trip)
#    click_on 'edit_trip'
#    find('input[name="commit"]').click
#    expect(current_path).to eq(trip_path(@trip))
#  end
#
#  it 'denies the superadmin to edit a trip' do
#    superadmin = FactoryBot.create(:user, superadmin: true)
#    login_as superadmin
#    visit edit_trip_path(@trip)
#    expect(current_path).to eq(dashboard_path)
#  end
end
