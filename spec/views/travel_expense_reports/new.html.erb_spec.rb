require 'rails_helper'

RSpec.describe "travel_expense_reports/new", type: :view do
  before(:each) do
    assign(:travel_expense_report, TravelExpenseReport.new(
      :trip => nil
    ))
  end

  it "renders new travel_expense_report form" do
    render

    assert_select "form[action=?][method=?]", travel_expense_reports_path, "post" do

      assert_select "input#travel_expense_report_trip_id[name=?]", "travel_expense_report[trip_id]"
    end
  end
end
