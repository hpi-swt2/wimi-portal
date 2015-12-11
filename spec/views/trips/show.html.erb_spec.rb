require 'rails_helper'

RSpec.describe 'trips/show', type: :view do
  before(:each) do
    @trip = assign(:trip, Trip.create!(title: 'ME310 Kickoff USA',
  start: Date.today - 3,
  end: Date.today,
  status: 'accepted',
  user_id: 1))
  end

  it 'renders attributes in <p>' do
    render
  end
end
