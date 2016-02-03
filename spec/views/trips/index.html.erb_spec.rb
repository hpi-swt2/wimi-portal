require 'rails_helper'

RSpec.describe 'trips/index', type: :view do
  before(:each) do
    @trip1 = FactoryGirl.create(:trip)
    @trip2 = FactoryGirl.create(:trip2)
    assign(:trips, [
      @trip1,
      @trip2
    ])
  end

  it 'renders a list of trips' do
    render
    expect(rendered).to match /#{@trip1.destination}/
    expect(rendered).to match /#{@trip2.destination}/
  end

  it 'denys the superadmin to see the list of trips' do
    superadmin = FactoryGirl.create(:user, superadmin: true)
    login_as superadmin
    visit trips_path
    expect(current_path).to eq(dashboard_path)
  end
end
