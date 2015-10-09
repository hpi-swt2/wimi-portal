require 'rails_helper'

RSpec.describe "trips/show", type: :view do
  before(:each) do
    @trip = assign(:trip, Trip.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
