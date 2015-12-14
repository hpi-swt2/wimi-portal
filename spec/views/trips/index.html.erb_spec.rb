require 'rails_helper'

RSpec.describe "trips/index", type: :view do
  before(:each) do
    @trip1 = FactoryGirl.create(:trip)
    @trip2 = FactoryGirl.create(:trip2)
    assign(:trips, [
        @trip1,
        @trip2
    ])
  end

  it "renders a list of trips" do
    render
    expect(rendered).to match /#{@trip1.name}/
    expect(rendered).to match /#{@trip2.name}/
  end
end
