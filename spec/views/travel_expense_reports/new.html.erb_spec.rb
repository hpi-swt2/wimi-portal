require 'rails_helper'

RSpec.describe "travel_expense_reports/new", type: :view do
  before(:each) do
    assign(:travel_expense_report, TravelExpenseReport.new())
  end

  it "renders new travel_expense_report form" do
    render

    assert_select "form[action=?][method=?]", travel_expense_reports_path, "post" do
    end
  end
end
