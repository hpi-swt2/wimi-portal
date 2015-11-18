require 'rails_helper'

RSpec.describe "work_days/new", type: :view do
  before(:each) do
    assign(:work_day, WorkDay.new(
      :brake => 1,
      :duration => 1,
      :attendance => "MyString",
      :notes => "MyString"
    ))
  end

  it "renders new work_day form" do
    render

    assert_select "form[action=?][method=?]", work_days_path, "post" do

      assert_select "input#work_day_brake[name=?]", "work_day[brake]"

      assert_select "input#work_day_duration[name=?]", "work_day[duration]"

      assert_select "input#work_day_attendance[name=?]", "work_day[attendance]"

      assert_select "input#work_day_notes[name=?]", "work_day[notes]"
    end
  end
end
