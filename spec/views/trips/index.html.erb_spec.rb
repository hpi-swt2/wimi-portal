require 'rails_helper'

RSpec.describe "trips/index", type: :view do
  before(:each) do
    assign(:trips, [
      Trip.create!(
        :name => "Name",
        :destination => "Destination",
        :reason => "MyText",
        :days_abroad => 1,
        :annotation => "MyText",
        :signature => "Signature"
      ),
      Trip.create!(
        :name => "Name",
        :destination => "Destination",
        :reason => "MyText",
        :days_abroad => 1,
        :annotation => "MyText",
        :signature => "Signature"
      )
    ])
  end

  it "renders a list of trips" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Destination".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Signature".to_s, :count => 2
  end
end
