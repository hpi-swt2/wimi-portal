require 'rails_helper'

RSpec.describe "work_days/show", type: :view do
  before(:each) do
    @work_day = assign(:work_day, WorkDay.create!(
      :brake => 1,
      :duration => 2,
      :attendance => "Attendance",
      :notes => "Notes"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Attendance/)
    expect(rendered).to match(/Notes/)
  end
end
