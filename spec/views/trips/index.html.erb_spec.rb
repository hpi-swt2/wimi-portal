require 'rails_helper'

RSpec.describe "trips/index", type: :view do
  before(:each) do
    assign(:trips, [
      Trip.create!(),
      Trip.create!()
    ])
  end

  it "renders a list of trips" do
    render
  end
end
