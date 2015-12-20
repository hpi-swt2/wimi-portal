require 'rails_helper'

RSpec.describe "trips/show", type: :view do
  before(:each) do
    @trip = assign(:trip, FactoryGirl.create(:trip))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Destination/)
    expect(rendered).to match(/Hana Things/)
    expect(rendered).to match(/NYC/)
    expect(rendered).to match(/signature/)
  end
end
