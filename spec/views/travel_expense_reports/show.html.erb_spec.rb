require 'rails_helper'

RSpec.describe "travel_expense_reports/show", type: :view do
  before(:each) do
    @travel_expense_report = assign(:travel_expense_report, FactoryGirl.create(:travel_expense_report))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First name/)
    expect(rendered).to match(/Last name/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Country/)
    expect(rendered).to match(/Location from/)
    expect(rendered).to match(/Location via/)
    expect(rendered).to match(/Location to/)
    expect(rendered).to match(/Hasso/)
    expect(rendered).to match(/2000/)
  end
end
