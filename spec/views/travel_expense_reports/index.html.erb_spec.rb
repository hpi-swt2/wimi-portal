require 'rails_helper'

RSpec.describe "travel_expense_reports/index", type: :view do
  before(:each) do
    assign(:travel_expense_reports, [
      TravelExpenseReport.create!(),
      TravelExpenseReport.create!()
    ])
  end

  it "renders a list of travel_expense_reports" do
    render
  end
end
