require 'rails_helper'

RSpec.describe "work_days/index", type: :view do
  before(:each) do
    assign(:work_days, [
      WorkDay.create!(
        :brake => 1,
        :duration => 2,
        :attendance => "Attendance",
        :notes => "Notes"
      ),
      WorkDay.create!(
        :brake => 1,
        :duration => 2,
        :attendance => "Attendance",
        :notes => "Notes"
      )
    ])
  end

  it "renders a list of work_days" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Attendance".to_s, :count => 2
    assert_select "tr>td", :text => "Notes".to_s, :count => 2
  end
end
