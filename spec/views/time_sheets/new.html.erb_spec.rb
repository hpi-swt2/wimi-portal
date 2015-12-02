require 'rails_helper'

RSpec.describe "time_sheets/new", type: :view do
  before(:each) do
    assign(:time_sheet, TimeSheet.new(
      :month => 1,
      :yeat => 1,
      :salary => 1,
      :salary_is_per_month => false,
      :workload => 1,
      :workload_is_per_month => false,
      :user_id => 1,
      :project_id => 1
    ))
  end

  it "renders new time_sheet form" do
    render

    assert_select "form[action=?][method=?]", time_sheets_path, "post" do

      assert_select "input#time_sheet_month[name=?]", "time_sheet[month]"

      assert_select "input#time_sheet_yeat[name=?]", "time_sheet[yeat]"

      assert_select "input#time_sheet_salary[name=?]", "time_sheet[salary]"

      assert_select "input#time_sheet_salary_is_per_month[name=?]", "time_sheet[salary_is_per_month]"

      assert_select "input#time_sheet_workload[name=?]", "time_sheet[workload]"

      assert_select "input#time_sheet_workload_is_per_month[name=?]", "time_sheet[workload_is_per_month]"

      assert_select "input#time_sheet_user_id[name=?]", "time_sheet[user_id]"

      assert_select "input#time_sheet_project_id[name=?]", "time_sheet[project_id]"
    end
  end
end
