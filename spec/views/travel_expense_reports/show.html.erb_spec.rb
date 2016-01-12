require 'rails_helper'

RSpec.describe "travel_expense_reports/show", type: :view do
  before(:each) do
    @travel_expense_report = assign(:travel_expense_report, FactoryGirl.create(:travel_expense_report))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Germany/)
    expect(rendered).to match(/NYC/)
    expect(rendered).to match(/2000/)
    expect(rendered).to match(/Potsdam/)
  end
end
