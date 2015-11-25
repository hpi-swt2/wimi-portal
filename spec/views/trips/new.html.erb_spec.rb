require 'rails_helper'

RSpec.describe "trips/new", type: :view do
  before(:each) do
    assign(:trip, Trip.new(
      :name => "MyString",
      :destination => "MyString",
      :reason => "MyText",
      :days_abroad => 1,
      :annotation => "MyText",
      :signature => "MyString"
    ))
  end

  it "renders new trip form" do
    render

    assert_select "form[action=?][method=?]", trips_path, "post" do

      assert_select "input#trip_name[name=?]", "trip[name]"

      assert_select "input#trip_destination[name=?]", "trip[destination]"

      assert_select "textarea#trip_reason[name=?]", "trip[reason]"

      assert_select "input#trip_days_abroad[name=?]", "trip[days_abroad]"

      assert_select "textarea#trip_annotation[name=?]", "trip[annotation]"

      assert_select "input#trip_signature[name=?]", "trip[signature]"
    end
  end
end
