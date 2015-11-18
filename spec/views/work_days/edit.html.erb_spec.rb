require 'rails_helper'

RSpec.describe "work_days/edit", type: :view do
  before(:each) do
    @work_day = assign(:work_day, WorkDay.create!(
      :brake => 1,
      :duration => 1,
      :attendance => "MyString",
      :notes => "MyString"
    ))
  end

  it "renders the edit work_day form" do
    render

    assert_select "form[action=?][method=?]", work_day_path(@work_day), "post" do

      assert_select "input#work_day_brake[name=?]", "work_day[brake]"

      assert_select "input#work_day_duration[name=?]", "work_day[duration]"

      assert_select "input#work_day_attendance[name=?]", "work_day[attendance]"

      assert_select "input#work_day_notes[name=?]", "work_day[notes]"
    end
  end
end
