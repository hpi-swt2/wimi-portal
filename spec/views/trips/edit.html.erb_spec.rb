require 'rails_helper'

RSpec.describe 'trips/edit', type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    FactoryGirl.create(:wimi, chair: FactoryGirl.create(:chair), user: @user)
    login_as @user
    @trip = assign(:trip, FactoryGirl.create(:trip, user: @user))
  end

  it 'renders the edit trip form' do
    render

    assert_select 'form[action=?][method=?]', trip_path(@trip), 'post' do
      assert_select 'input#trip_destination[name=?]', 'trip[destination]'

      assert_select 'textarea#trip_reason[name=?]', 'trip[reason]'

      assert_select 'textarea#trip_annotation[name=?]', 'trip[annotation]'

      assert_select 'input#trip_signature[name=?]', 'trip[signature]'
    end
  end

  it 'shows the trip detail page after editing' do
    visit trip_path(@trip)
    click_on I18n.t('helpers.links.edit')
    find('input[name="commit"]').click
    expect(current_path).to eq(trip_path(@trip))
  end

  it 'denies the superadmin to edit a trip' do
    superadmin = FactoryGirl.create(:user, superadmin: true)
    login_as superadmin
    visit edit_trip_path(@trip)
    expect(current_path).to eq(dashboard_path)
  end
end
