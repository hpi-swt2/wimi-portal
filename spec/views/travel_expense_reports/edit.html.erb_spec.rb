require 'rails_helper'

RSpec.describe "travel_expense_reports/edit", type: :view do
  before(:each) do
    @travel_expense_report = assign(:travel_expense_report, TravelExpenseReport.create!())
  end

  it "renders the edit travel_expense_report form" do
    render

    assert_select "form[action=?][method=?]", travel_expense_report_path(@travel_expense_report), "post" do
    end
  end
end
