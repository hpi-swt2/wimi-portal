require 'rails_helper'

RSpec.describe "trips/edit", type: :view do
  before(:each) do
    @trip = assign(:trip, Trip.create!(
      :name => "MyString",
      :destination => "MyString",
      :reason => "MyText",
      :days_abroad => 1,
      :annotation => "MyText",
      :signature => "MyString"
    ))
  end

  it "renders the edit trip form" do
    render

    assert_select "form[action=?][method=?]", trip_path(@trip), "post" do

      assert_select "input#trip_name[name=?]", "trip[name]"

      assert_select "input#trip_destination[name=?]", "trip[destination]"

      assert_select "textarea#trip_reason[name=?]", "trip[reason]"

      assert_select "input#trip_days_abroad[name=?]", "trip[days_abroad]"

      assert_select "textarea#trip_annotation[name=?]", "trip[annotation]"

      assert_select "input#trip_signature[name=?]", "trip[signature]"
    end
  end
end
