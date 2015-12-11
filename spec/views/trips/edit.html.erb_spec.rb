require 'rails_helper'

RSpec.describe 'trips/edit', type: :view do
  before(:each) do
    @trip = assign(:trip, Trip.create!(title: 'ME310 Kickoff USA',
      start: Date.today - 3,
      end: Date.today,
      status: 'accepted',
      user_id: 1))
  end

  it 'renders the edit trip form' do
    render

    assert_select 'form[action=?][method=?]', trip_path(@trip), 'post' do
    end
  end
end
