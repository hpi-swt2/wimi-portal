require 'rails_helper'

RSpec.describe 'trips/new', type: :view do
  before(:each) do
    assign(:trip, Trip.new)
  end

  it 'renders new trip form' do
    render
    assert_select 'form[action=?][method=?]', trips_path, 'post' do
    end
  end

  it 'denys the superadmin to create a new trip' do
    superadmin = FactoryGirl.create(:user, superadmin: true)
    login_as superadmin
    visit new_trip_path
    expect(current_path).to eq(dashboard_path)
  end
end
