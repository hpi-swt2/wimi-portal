require 'rails_helper'

RSpec.describe "travel_expense_reports/show", type: :view do
  before(:each) do
    @travel_expense_report = assign(:travel_expense_report, TravelExpenseReport.create!(
      :trip => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
  end
end
