require 'rails_helper'

RSpec.describe "travel_expense_reports/show", type: :view do
  before(:each) do
    @travel_expense_report = assign(:travel_expense_report, TravelExpenseReport.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
