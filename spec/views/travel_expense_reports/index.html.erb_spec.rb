require 'rails_helper'

RSpec.describe 'travel_expense_reports/index', type: :view do
  before(:each) do
    assign(:travel_expense_reports, [
      FactoryGirl.create(:travel_expense_report),
      FactoryGirl.create(:travel_expense_report_changed)
    ])
  end

  it 'renders a list of travel_expense_reports' do
    render
    expect(rendered).to match /2000/
    expect(rendered).to match /Hana Things/
    expect(rendered).to match /1337/
  end
end
