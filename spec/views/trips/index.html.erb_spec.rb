require 'rails_helper'

RSpec.describe 'trips/index', type: :view do
  before(:each) do
    assign(:trips, [
      Trip.create!(title: 'ME310 Kickoff USA',
  start: Date.today - 3,
  end: Date.today,
  status: 'accepted',
  user_id: 1),
      Trip.create!(title: 'ME310 Kickoff USA',
  start: Date.today - 3,
  end: Date.today,
  status: 'accepted',
  user_id: 1)
    ])
  end

  it 'renders a list of trips' do
    render
  end
end
