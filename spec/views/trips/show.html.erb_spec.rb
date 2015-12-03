require 'rails_helper'

RSpec.describe "trips/show", type: :view do
  before(:each) do
    @trip = assign(:trip, FactoryGirl.create(:trip))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Destination/)
    expect(rendered).to match(/Hana Travels/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/HANA pls/)
    expect(rendered).to match(/Signature/)
  end
end
