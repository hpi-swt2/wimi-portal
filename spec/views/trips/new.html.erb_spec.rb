require 'rails_helper'

RSpec.describe 'trips/new', type: :view do
  before(:each) do
    assign(:trip, Trip.new(title: 'ME310 Kickoff USA',
  start: Date.today - 3,
  end: Date.today,
  status: 'accepted',
  user_id: 1))
  end

  it 'renders new trip form' do
    render

    assert_select 'form[action=?][method=?]', trips_path, 'post' do
    end
  end
end
